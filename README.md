# lilypond-bamboo-flute-markup

> [中文版本 / Chinese version](README-zh.md)

Automatically annotate LilyPond scores with bamboo flute finger diagrams,
blow-strength indicators, and jianpu (numbered musical notation).

## What it does

Given a LilyPond score (e.g. `testcase.ly`), the script produces two annotated
outputs:

| Output | Purpose | Content |
|---|---|---|
| `testcase-practice.ly` | Practice | Finger diagrams + jianpu + numbered note heads — every note is annotated, ideal for self-study |
| `testcase-perform.ly` | Performance | Jianpu only — clean and minimal, suitable for stage or rehearsal |

## Usage

### Dependencies

- Python 3
- [LilyPond](https://lilypond.org/) 2.24 (must be on PATH)

### One command

```bash
python bamboo_flute_markup.py
```

This runs the full 6-step pipeline: compile input → generate markup → produce
both output files → compile each to PDF.  Stops immediately on any error.

### Manual compile

```bash
lilypond testcase.ly             # compile raw input
lilypond testcase-practice.ly    # compile practice score
lilypond testcase-perform.ly     # compile performance score
```

## Preparing the input

1. Write a standard LilyPond `.ly` file (`\fixed c'`, `\relative`, or absolute mode)
2. Mark the note passage to annotate with `% score begin` and `% score end`
3. Optionally add a `lyric = \lyricmode{...}` block for lyrics
4. A MIDI `\score` block containing `\midi { }` may be included; it is
   automatically removed from both outputs

Minimal example:

```lilypond
\version "2.24.3"
\language english

#(set-global-staff-size 26)

melody = \fixed c' {
  \clef treble
  \key c \major
  \time 4/4

  % score begin
  c4 d e f | g2 c
  % score end
}

\score {
  \new Staff \melody
  \layout { }
}
```

## Project structure

| File | Role |
|---|---|
| `bamboo_flute_markup.py` | Core script — reads `.ly`, generates markup, writes both outputs |
| `testcase.ly` | Input — hand-edited LilyPond score |
| `testcase-practice.ly` | Output — practice score (finger diagrams + jianpu + numbered heads) |
| `testcase-perform.ly` | Output — performance score (jianpu only, clean) |

## How it works

The script uses regular expressions (no full LilyPond parser) to match and
replace note tokens.  Core pipeline:

1. Detect key signature (`\key`) and octave entry mode (`\fixed` / `\relative` / absolute)
2. Expand LilyPond abbreviation notation (`c'4 b b8` → `c'4 b4 b8`)
3. Normalize all notes to absolute octave mode for consistent processing
4. Two `re.sub` passes over the score:
   - Add `\woodwind-diagram` finger diagrams and `+` blow-strength marks to each note
   - Convert each note to a jianpu number `\markup{...}`
5. Substitute annotated content into the score, insert a jianpu variable block,
   remove the MIDI `\score`, and compile

Note-to-finger mapping is based on: **tonality** (e.g. C / G / F) → MIDI number
of the flute's lowest note → pitch interval → finger chart lookup.

## License

See the LICENSE file.