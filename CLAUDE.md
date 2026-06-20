# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project structure

```
lilypond-bamboo-flute-markup/
├── bamboo_flute_markup.py    # Main processing script: generates practice & perform .ly files
├── testcase.ly               # Input template: raw LilyPond score (hand-edited)
├── testcase-practice.ly      # Generated: practice mode (finger diagrams, jianpu, easyHeadsOn)
├── testcase-perform.ly       # Generated: performance mode (jianpu only, clean notes)
├── CLAUDE.md                 # Project instructions for Claude Code (this file)
├── README.md                 # Project overview (bilingual: Chinese / English)
├── LICENSE                   # Open-source license
├── .gitignore                # Git ignore rules (Python + LilyPond build artifacts: *.pdf *.mid *.ps)
├── .claudeignore             # Claude Code ignore rules
└── .claude/                  # Claude Code session data
    └── settings.local.json   # Local project settings for Claude Code
```

### File roles

| File | Category | Description |
|------|----------|-------------|
| `bamboo_flute_markup.py` | Source | Single-file Python script (~1314 lines). Orchestrates the full 6-step pipeline: reads `testcase.ly`, generates finger placement and jianpu markup, produces `testcase-practice.ly` and `testcase-perform.ly`, compiles both with LilyPond. |
| `testcase.ly` | Input | Hand-edited LilyPond score with `% score begin` / `% score end` markers. Contains `melody`, optional `lyric`, a display `\score`, and a MIDI `\score`. |
| `testcase-practice.ly` | Output (generated) | Practice mode: finger diagrams on every note, `\easyHeadsOn`, `\textLengthOn`, `\consists \Ez_numbers_engraver`, jianpu lyrics, no MIDI block. |
| `testcase-perform.ly` | Output (generated) | Performance mode: clean notes, jianpu lyrics only, no finger diagrams, no `\easyHeadsOn`, no MIDI block. |
| `CLAUDE.md` | Config | Instructions and architectural documentation for Claude Code. |
| `README.md` | Config | Bilingual project overview (Chinese + English), includes TODO items. |
| `LICENSE` | Config | Open-source license file. |
| `.gitignore` | Config | Excludes Python bytecode, virtual environments, IDE config, and LilyPond build artifacts (`*.pdf`, `*.ps`, `*.midi`, `*.mid`). |
| `.claudeignore` | Config | Excludes files from Claude Code context (e.g. large generated files). |
| `.claude/` | Config | Claude Code session data (settings, memory, plans). Not committed in some workflows. |

Generated build artifacts (not tracked, excluded by `.gitignore`):

| Artifact | Source | Description |
|----------|--------|-------------|
| `testcase.pdf` | `lilypond testcase.ly` | PDF from raw input compilation |
| `testcase.mid` | `lilypond testcase.ly` | MIDI from raw input (if MIDI block present) |
| `testcase-practice.pdf` | `lilypond testcase-practice.ly` | PDF of practice score |
| `testcase-perform.pdf` | `lilypond testcase-perform.ly` | PDF of performance score |

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
lilypond testcase.ly           # raw input, no annotations
lilypond testcase-practice.ly  # practice mode: finger diagrams, jianpu, easyHeadsOn, numbered note heads
lilypond testcase-perform.ly   # perform mode: jianpu only, clean notes
```

The `__main__` block in `bamboo_flute_markup.py` orchestrates the full pipeline
(see below) — it is the one-command entry point.

## Architecture

A single Python script (`bamboo_flute_markup.py`) that reads LilyPond `.ly`
files and adds bamboo flute markup via regex-based note substitution.  No
LilyPond parser is involved — all processing is done with `re.sub`.

### Data structures

Four module-level dictionaries define the mapping knowledge:

| Dictionary | Maps | Example |
|------------|------|---------|
| `PITCH_NAME_DICT` | pitch class (0–11) → LilyPond name variants | `2: ["d"]`, `6: ["fs", "gf"]` |
| `ACCIDENTAL_DICT` | accidental offset → LilyPond notation variants | `-1: ["f", "-flat"]`, `1: ["s", "-sharp"]` |
| `JIANPU_NUM_DICT` | scale degree (0–11) → jianpu number strings | `0: ["1"]`, `7: ["5"]` |
| `FINGER_PLACEMENT_DICT` | bamboo pitch (0–31) → finger hole patterns | `7: ["one two"]`, `10: ["two three", "one1h", …]` |

Module-level constants:

- `EZ_NUMBERS_ENGRAVER_DEF` — Scheme engraver that prints scale-degree numbers inside note heads
- `_LAYOUT_WITH_ENGRAVER` — `\layout` block template with `\consists \Ez_numbers_engraver`
- `BREATH_ALIGNMENT_BLANKS` — filler blanks for vertical alignment of ∨ breath marks on tie-continuation notes

### Preprocessing pipeline (reading the input)

Before any markup is generated, the raw score code goes through these steps:

1. **Detect octave entry mode** — `get_octave_entry_mode()` scans for
   `\fixed c'`, `\relative c'`, or defaults to absolute mode.  Returns a
   `(mode, value)` tuple: for fixed/absolute, the value is the base octave
   number (e.g. 4 for `\fixed c'`); for relative, it's the MIDI number of
   the reference pitch (e.g. 60 for `c'`).

2. **Detect key signature** — `get_key_signature()` parses `\key <pitch>
   \major` or `\minor`.  Minor keys are converted to their relative major
   (e.g. A minor → C).  Defaults to `"C"` if no `\key` command is found.

3. **Expand abbreviations** — `_expand_abbreviations()` fills in omitted
   pitches and durations in LilyPond's shorthand notation:
   `c'4 b b8 → c'4 b4 b8`.  Crucially, `\volta` and `\repeat volta`
   numeric arguments are temporarily encoded as placeholders to prevent
   them from being matched as duration-only abbreviated notes.

4. **Normalize to absolute mode** — `_normalize_to_absolute()` converts
   relative-mode notation to absolute mode by simulating LilyPond's
   proximity rule (each note placed in the octave that makes the interval
   ≤ a perfect 4th from the previous note).  Fixed-mode notation is
   adjusted by a uniform octave offset.  After this step, every note has
   explicit `'` and `,` octave marks.

### Validation

`BambooFlute.validate()` checks the expanded, absolute-mode score for:

- **Range**: every pitched note must be within the flute's 32-semitone
  playable range (tube pitch to tube pitch + 31).  Reports the line
  number and MIDI value if out of range.
- **\\breathe placement**: every `\breathe` command must be immediately
  preceded by a pitched note (not a bar line, break, or whitespace only).

### BambooFlute class — core engine

#### Initialization

`BambooFlute(tonality, finger_placement_mode)` sets up:

- `tube_pitch_midi_num` — the MIDI number of the lowest playable note for
  the given tonality (e.g. C → MIDI 55 = G3, G → MIDI 60 = C4).
- `pitch_num_dict` — maps MIDI note numbers (55–86) to bamboo flute pitch
  numbers (0–31), computed by `midi_num - tube_pitch_midi_num`.
- `tie` — a boolean state tracking whether the previous note had a `~`
  tie.  Reset at the start of each processing pass.

#### Two parallel processing passes

Both passes operate on the same expanded/absolute-mode score code, each
via a `re.sub` that replaces every note match:

1. **`add_finger_placement_markup()`** — produces `score_markup`, the
   melody with finger diagrams:
   - Converts each note: MIDI → bamboo pitch → finger hole pattern (from
     `FINGER_PLACEMENT_DICT[0]`).
   - Appends `^\markup{\center-column{\woodwind-diagram #'tin-whistle
     …}}` finger diagram markup.
   - High-octave notes (bamboo pitch ≥ 12) also get `^\markup{+}` blow
     strength indicators (one `+` per octave above the base).
   - `\breathe` commands are consumed: the preceding note gets a ∨ breath
     mark, combined with blow strength into a single markup.
   - Tie continuations (`self.tie` is True) and rests: no finger markup.
     Tie-continuation `\breathe` notes get a padded breath mark for
     vertical alignment via `BREATH_ALIGNMENT_BLANKS`.

2. **`get_jianpu_lyrics()`** — produces `jianpu_lyrics`, a string of
   numbered notation:
   - Converts each note: MIDI → bamboo pitch → jianpu number (via
     `JIANPU_NUM_DICT`, offset by finger placement mode root).
   - Octave dots: low octave (jianpu_octave < 1) → dots below via
     `\center-column{\vspace …}`; high octave (> 1) → dots above.
   - Underlines: notes with `note_value_main ≤ 1/4` get `\underline`
     prefixes (1 for eighth, 2 for sixteenth, etc.).
   - Duration lines: quarter notes and longer get trailing hyphens
     proportional to duration (e.g. half note → one `-`).
   - Tie continuations: re-notated with parentheses `(6)`.
   - Converts `\volta N, M` (comma-separated, valid in music mode) to
     `\volta #'(N M)` (Scheme list, required in `\lyricmode`).
   - Breath marks: appends `\super "∨"` to the note before `\breathe`.

#### Note parsing (shared regex)

Both passes use the same regex pattern to match notes:

```
(pitch)(accidental)(octave)(duration)(dots)(tie/slur)(whitespace)(\breathe?)(whitespace)(barline?)(whitespace)
```

Groups: `g(1)=pitch`, `g(2)=accidental`, `g(3)=octave`, `g(4)=duration`,
`g(5)=dots`, `g(6)=tie/slur`, `g(7)=ws`, `g(8)=breathe`, `g(9)=ws`,
`g(10)=barline`.

### Helper functions (used by the pipeline)

| Function | Purpose |
|----------|---------|
| `_build_jianpu_block(jianpu_lyrics)` | Wraps raw jianpu `\markup` expressions into `jianpu = \lyricmode { … }` variable block |
| `_insert_jianpu_into_score(content, jianpu_lyrics)` | Inserts jianpu variable before the first `\score` block, then adds `\new Lyrics \jianpu` after `} \melody` |
| `_remove_midi_score(content)` | Locates `\midi`, counts braces to find the enclosing `\score` block, removes it |
| `_strip_trailing_whitespace(content)` | Strips trailing whitespace from every line |

### File conventions

- `testcase.ly` — input test file: raw LilyPond score with `% score begin` / `% score end` markers
- `testcase-practice.ly` — generated practice output: finger diagrams + jianpu + `\textLengthOn` + `\easyHeadsOn` + `\consists \Ez_numbers_engraver` in `\layout` for numbered note heads. MIDI `\score` block removed.
- `testcase-perform.ly` — generated performance output: jianpu only, clean notes, no finger diagrams, no easy-heads. MIDI `\score` block removed.

### Workflow: automated pipeline

After editing `bamboo_flute_markup.py` or `testcase.ly`, regenerate both output
files by running:

```bash
python bamboo_flute_markup.py
```

The script performs the following steps in order. **If any step fails, it stops
immediately.**

1. `lilypond testcase.ly` — compile the raw (unannotated) score to verify it
   is valid LilyPond input
2. **Generate markup** — import the `bamboo_flute_markup` module to produce:
   - `score_with_markup`: the melody with `^\markup{\woodwind-diagram…}` finger
      diagrams and `^\markup{+}` blow-strength indicators
   - `jianpu_lyrics`: a sequence of `\markup{…}` expressions in numbered notation
3. **Generate** `testcase-practice.ly` — copy `testcase.ly`, then:
   - Insert `#(define Ez_numbers_engraver …)` Scheme definition before
     `#(set-global-staff-size 26)`
   - Insert `\textLengthOn` and `\easyHeadsOn` before `% score begin`
   - Replace note content between `% score begin` / `% score end` with
     `score_with_markup` (finger diagrams)
   - Insert `jianpu = \lyricmode { … }` variable after the `melody` block
   - Add `\new Lyrics \jianpu` to the display `\score` block
   - Replace `\layout { }` with engraver-enabled version (containing
     `\consists \Ez_numbers_engraver`)
   - Remove the MIDI `\score` block
   - Strip trailing whitespace
4. `lilypond testcase-practice.ly` — compile practice score to PDF
5. **Generate** `testcase-perform.ly` — copy `testcase.ly`, then:
   - Leave notes between `% score begin` / `% score end` unchanged (clean, no
     finger markup)
   - Insert `jianpu = \lyricmode { … }` variable after the `melody` block
   - Add `\new Lyrics \jianpu` to the display `\score` block
   - Remove the MIDI `\score` block
   - Strip trailing whitespace
6. `lilypond testcase-perform.ly` — compile performance score to PDF

Open `testcase-practice.pdf` and `testcase-perform.pdf` to verify the results.

#### Key details for the pipeline steps

- **`\volta` format conversion**: `get_jianpu_lyrics()` automatically converts
  `\volta N, M` (comma-separated, valid in music mode) to `\volta #'(N M)`
  (Scheme list, required in `\lyricmode`).
- **`lyric` variable**: The `lyric = \lyricmode{…}` block from `testcase.ly`
  is preserved as-is in both outputs. The pipeline handles both the presence
  and absence of this block.
- **MIDI block removal**: `_remove_midi_score()` uses brace counting from the
  `\midi` keyword to find and remove the enclosing `\score` block.
- **Helper functions**: `_build_jianpu_block()`, `_insert_jianpu_into_score()`,
  `_remove_midi_score()`, `_strip_trailing_whitespace()` — extracted to keep
  the `__main__` block readable.

## `.ly` file formats

### `testcase.ly` — input template

The source file that the pipeline reads. It contains:

```
\header { title / subtitle / copyright / tagline }
\paper { a4, page-number settings }
#(set-global-staff-size 26)

melody = \fixed c' {        ← octave entry mode (also supports \relative or absolute)
  \clef treble
  \key d \major
  \time 3/4
  \tempo 4 = 120
  \set Score.barNumberVisibility = #all-bar-numbers-visible

  % score begin            ← delimiter: everything between here and % score end is processed
  e8 b8 g8 fs8 d4 | ...    ← notes: standard pitch names, durations, ties (~), barlines (|)
  \repeat volta 4 { ... }  ← repeats with \alternative{ \volta 1,2{...} \volta 3{...} }
  % score end
}

lyric = \lyricmode{ ... }   ← optional: lyrics with << { } \new Lyrics { } >> stanzas

\score {                    ← display score: Staff + Lyrics + \layout { }
  << \new Staff ... \melody \new Lyrics \lyric >>
  \layout { }
}

\score {                    ← MIDI score (removed in both outputs)
  \new Staff ... \unfoldRepeats { \melody } \midi { }
}
```

**Requirements for the input file:**
- Use one of LilyPond's octave entry modes (`\fixed c'`, `\relative`, or absolute)
- Contain `% score begin` and `% score end` markers delimiting the passage to annotate
- Use note syntax the regex can parse: standard pitch names (`c d e f g a b r`), optional accidentals, octave marks (`' ,`), duration numbers, dots, and tie/slur symbols

### `testcase-practice.ly` — practice mode (generated)

Built from `testcase.ly` with these changes applied:

| Section | Change |
|---------|--------|
| Before `#(set-global-staff-size 26)` | Insert `#(define Ez_numbers_engraver …)` Scheme engraver definition |
| Before `% score begin` | Insert `\textLengthOn` and `\easyHeadsOn` (each on its own line) |
| `% score begin` … `% score end` | Each note gets `^\markup{\center-column{\woodwind-diagram #'tin-whistle …}}` finger diagram; high-octave notes also get `^\markup{+}` blow strength |
| After `melody` block, before first `\score` | Insert `jianpu = \lyricmode { \markup{…} … }` with numbered notation; `\volta N,M` converted to `\volta #'(N M)` |
| Display `\score` | Add `\new Lyrics \jianpu`; `\layout { }` replaced with `\layout { \context { \Voice \consists \Ez_numbers_engraver } }` |
| MIDI `\score` | Removed entirely |
| `lyric` variable | Preserved as-is from input |
| Trailing whitespace | Stripped from every line |

### `testcase-perform.ly` — performance mode (generated)

Built from `testcase.ly` with these changes applied:

| Section | Change |
|---------|--------|
| `% score begin` … `% score end` | **Unchanged** — clean notes, no finger diagrams |
| After `melody` block, before first `\score` | Insert `jianpu = \lyricmode { \markup{…} … }` |
| Display `\score` | Add `\new Lyrics \jianpu`; `\layout { }` remains empty |
| MIDI `\score` | Removed entirely |
| `lyric` variable | Preserved as-is from input |
| Trailing whitespace | Stripped from every line |
