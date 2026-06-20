# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Coding standards

All Python code must strictly follow the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html). Key points relevant to this codebase:

- **Naming**: `snake_case` for functions and variables, `CamelCase` for classes, `UPPER_CASE` for module-level constants
- **Line length**: maximum 80 characters
- **Imports**: `import` vs `from` per Google rules (use `import` for modules, `from` for specific names); group as standard library → third-party → local, each group alphabetically sorted
- **Docstrings**: Use reStructuredText format (`"""Summary.` followed by `Args:` / `Returns:` / `Raises:` sections as needed) on every public module, function, class, and method
- **Type annotations**: Required on all function signatures (both parameters and return types)
- **Tuples**: Parenthesized with explicit parentheses
- **Comprehensions**: Allowed only for simple cases; avoid deeply nested comprehensions or `filter`/`map` with lambdas

## Commands

```bash
# Full automated workflow (runs all 6 steps below)
python bamboo_flute_markup.py

# Compile with LilyPond (requires LilyPond on PATH)
lilypond testcase.ly        # raw notes, no annotations
lilypond testcase-output.ly  # annotated output
```

The `__main__` block in `bamboo_flute_markup.py` orchestrates the full pipeline
(see below) — it is the one-command entry point.

## Architecture

A single Python script (`bamboo_flute_markup.py`) that reads LilyPond `.ly` files and adds bamboo flute markup via regex-based note substitution.

### Processing pipeline

1. **Parse entry mode** — `get_octave_entry_mode()` reads `\fixed c'` / `\relative` / absolute mode from the script
2. **Extract score** — `get_score_code()` finds the region between `% score begin` and `% score end`
3. **Two parallel passes** over the extracted score, each a `re.sub` that replaces every note match:
   - `add_finger_placement_markup()` → produces the `melody` variable with `^\markup{\woodwind-diagram...}` and `^\markup{+}` blow strength
   - `get_jianpu_lyrics()` → produces the `jianpu` variable with `\markup{...}` formatted numbered notation

### Key design details

- **Note parsing**: Each note is matched by regex groups: `(pitch)(accidental)(octave)(duration)(dots)(tie/slur)(whitespace)(barline?)`. No LilyPond parser is involved.
- **MIDI → bamboo pitch mapping**: A `pitch_num_dict` maps MIDI note numbers 55–86 to bamboo flute pitch numbers 0–31, computed from the tonality setting (e.g., "C" → tube_pitch = MIDI 55).
- **Octave dots**: Jianpu uses `\center-column` with `\vspace` adjustments for octave dots above/below the number. Low octave (< 1) gets dots below; high octave (> 1) gets dots above.
- **Underlines**: Notes with `note_value_main <= 1/4` (eighth or shorter) get `\underline` prepended. The number of `\underline` prefixes corresponds to the power of 2: eighth = 1, sixteenth = 2.
- **Tie state machine** (`self.tie`): Tracks whether the previous note had a `~` tie. When `self.tie` is true:
  - Finger placement skips the note entirely
  - Jianpu produces either hyphens (if duration is an integer multiple of 1/4 beat) or parenthesized notation (otherwise)
  - State is reset at the start of each processing pass
- **Finger placement**: `FINGER_PLACEMENT_DICT` maps 32 bamboo pitch numbers to hole patterns like `"one two three four five six"`. Blow strength (`+` signs) increases for higher octaves.

### File conventions

- `testcase.ly` — input test file: raw LilyPond score with `% score begin` / `% score end` markers
- `testcase-output.ly` — annotated output: `melody` variable (with finger markup) + `jianpu` variable (with jianpu markup) + `\score` combining both in parallel

### Workflow: automated pipeline

After editing `bamboo_flute_markup.py` or `testcase.ly`, regenerate the annotated
output by running:

```bash
python bamboo_flute_markup.py
```

The script performs the following steps in order. **If any step fails, it stops
immediately.**

1. `lilypond testcase.ly` — compile the raw (unannotated) score to verify it
   is valid LilyPond input
2. **Copy** `testcase.ly` to `testcase-output.ly` (overwriting if it exists)
3. **Generate markup** — import the `bamboo_flute_markup` module to produce:
   - `score_with_markup`: the melody with `^\markup{\woodwind-diagram…}` finger
      diagrams and `^\markup{+}` blow-strength indicators
   - `jianpu_lyrics`: a sequence of `\markup{…}` expressions in numbered notation
4. **Replace score body** — within `testcase-output.ly`:
   - Insert `\textLengthOn` on its own line before `% score begin`
   - Replace the note content between `% score begin` and `% score end` with
     `score_with_markup`
5. **Insert jianpu lyrics** — after the `melody = …` block, add a new variable
   `jianpu = \lyricmode { … }` containing the jianpu markup, and restructure
   the `\score` block to use `<< … >>` with both `\melody` and `\new Lyrics
   \jianpu`
6. **Format** — strip trailing whitespace from every line
7. `lilypond testcase-output.ly` — compile the annotated score to PDF

Open `testcase-output.pdf` to verify the result.

## `.ly` file format

Input files must:
- Use one of LilyPond's octave entry modes (`\fixed c' { ... }`, `\relative { ... }`, or absolute)
- Contain `% score begin` and `% score end` markers delimiting the passage to annotate
- Use note syntax that the regex can parse: standard pitch names (`c d e f g a b r`), optional accidentals, octave marks (`' ,`), duration numbers, dots, and tie/slur symbols
