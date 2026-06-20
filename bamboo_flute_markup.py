"""Add bamboo flute markup to LilyPond scores.

Parses LilyPond .ly files and generates finger placement diagrams and
jianpu (numbered musical notation) lyrics for bamboo flute.
"""

import math
import os
import re
import shutil
import subprocess
import sys
from typing import Optional

# Mapping from pitch class to pitch name strings used in LilyPond.
# Each chromatic pitch class lists both flat and sharp spellings; the
# first entry is the preferred variant when auto-selecting a tonality.
PITCH_NAME_DICT: dict[int, list[str]] = {
    0: ["c"],
    1: ["df", "cs"],
    2: ["d"],
    3: ["ef", "ds"],
    4: ["e"],
    5: ["f"],
    6: ["fs", "gf"],
    7: ["g"],
    8: ["af", "gs"],
    9: ["a"],
    10: ["bf", "as"],
    11: ["b"],
}

# Mapping from accidental offset to notation variants in LilyPond.
ACCIDENTAL_DICT: dict[int, list[str]] = {
    -2: ["ff", "-flatflat", "\U0001d12b"],
    -1: ["f", "-flat", "♭"],
    0: ["!", "?", "♮"],
    1: ["s", "-sharp", "♯"],
    2: ["ss", "x", "-sharpsharp", "𝄪"],
}

# Mapping from scale degree to jianpu number notation strings.
JIANPU_NUM_DICT: dict[int, list[str]] = {
    0: ["1"],
    1: ["♯1", "♭2", "♯1/♭2"],
    2: ["2"],
    3: ["♯2", "♭3", "♯2/♭3"],
    4: ["3"],
    5: ["4"],
    6: ["♯4", "♭5", "♯4/♭5"],
    7: ["5"],
    8: ["♯5", "♭6", "♯5/♭6"],
    9: ["6"],
    10: ["♯6", "♭7", "♯6/♭7"],
    11: ["7"],
}

# Filler blanks used in \center-column so that the breath-mark ∨ on
# a tie-continuation note (which has no finger diagram) aligns vertically
# with the ∨ that appears on notes that do have a finger diagram.
BREATH_ALIGNMENT_BLANKS = '" " " " " " " " " " " "'

# Scheme definition of the Ez_numbers_engraver that prints scale-degree
# numbers inside note heads.  Inserted into testcase-practice.ly.
EZ_NUMBERS_ENGRAVER_DEF = (
    r"#(define Ez_numbers_engraver" "\n"
    r"   (make-engraver" "\n"
    r"    (acknowledgers" "\n"
    r"     ((note-head-interface engraver grob source-engraver)" "\n"
    r"      (let* ((context (ly:translator-context engraver))" "\n"
    r"       (tonic-pitch (ly:context-property context 'tonic))" "\n"
    r"       (tonic-name (ly:pitch-notename tonic-pitch))" "\n"
    r"       (grob-pitch" "\n"
    r"        (ly:event-property (event-cause grob) 'pitch))" "\n"
    r"       (grob-name (ly:pitch-notename grob-pitch))" "\n"
    r"       (delta (modulo (- grob-name tonic-name) 7))" "\n"
    r"       (note-names" "\n"
    r"        (make-vector 7 (number->string (1+ delta)))))" "\n"
    r"  (ly:grob-set-property! grob 'note-names note-names))))))"
)

# \\layout block template with Ez_numbers_engraver context for practice mode.
_LAYOUT_WITH_ENGRAVER = (
    r"\layout {"
    "\n"
    r"    \context {"
    "\n"
    r"      \Voice"
    "\n"
    r"      \consists \Ez_numbers_engraver"
    "\n"
    r"    }"
    "\n"
    r"  }"
)


def get_octave_entry_mode(script: str) -> tuple[str, int]:
    """Detect octave entry mode and reference number from a LilyPond script.

    Scans for \\fixed, \\relative, or defaults to absolute mode.

    Args:
        script: Raw LilyPond source text.

    Returns:
        A tuple of (mode, value), where mode is one of \"fixed\",
        \"relative\", or \"absolute\".  For fixed/absolute, the value
        is the base octave number.  For relative, the value is the
        MIDI number of the reference pitch.
    """
    octave_base_num = 3
    match_obj = re.search(
        r"\\fixed\s*(c|d|e|f|g|a|b)(ff|f|s|ss|x)?"
        r"(,*|'*)\s*\{",
        script,
        flags=re.IGNORECASE)
    if match_obj:
        octave = match_obj.group(3)
        if octave:
            octave_base_num += -octave.count(",") + octave.count("'")
        return "fixed", octave_base_num
    match_obj = re.search(
        r"\\relative\s*"
        r"(c|d|e|f|g|a|b)?"
        r"(ff|f|s|ss|x)?"
        r"(,*)"
        r"('*)"
        r"\s*\{",
        script,
        flags=re.IGNORECASE)
    if match_obj:
        if not match_obj.group(1):
            # No explicit reference pitch: LilyPond defaults to c'.
            return "relative", 60
        pitch = match_obj.group(1).lower()
        ref_pc = 0
        for pc, names in PITCH_NAME_DICT.items():
            if pitch in names:
                ref_pc = pc
                break
        octave_relative = (
            -match_obj.group(3).count(",") + match_obj.group(4).count("'"))
        octave_num = 3 + octave_relative
        ref_midi = 12 * (octave_num + 1) + ref_pc
        return "relative", ref_midi
    return "absolute", octave_base_num


def get_score_code(script: str) -> Optional[re.Match]:
    """Extract the score region between begin/end markers.

    The markers are \"% score begin\" and \"% score end\" as LilyPond
    comments delimiting the passage to annotate.

    Args:
        script: Raw LilyPond source text.

    Returns:
        A regex match object whose group(1) is the score content, or
        None if no markers are found.
    """
    match_obj = re.search(
        r"%\s*score\s*begin(.*)%\s*score\s*end",
        script,
        re.IGNORECASE | re.DOTALL)
    if not match_obj:
        print("Score code not found.")
    return match_obj


_NOTE_EVENT_RE = re.compile(
    r"(?:(?<![a-zA-Z\\])(?P<pitch1>[cdefgabr](?:ff|f|!|\?|s|ss|x)?[,']*)"
    r"(?P<dur1>\d+|\\breve|\\longa)?(?P<dots1>\.*))"
    r"|"
    r"(?:(?P<octave2>[,']*)(?P<dur2>\d+|\\breve|\\longa)"
    r"(?P<dots2>\.*))",
    re.IGNORECASE)

# Regex for matching fully expanded (pitch+duration) note tokens.
# Used by _adjust_octave_marks and _relative_to_absolute to rewrite
# octave marks without touching non-note text.
_EXPANDED_NOTE_RE = re.compile(
    r"(?<![a-zA-Z\\])"
    r"(?P<pitch>[cdefgabr])"
    r"(?P<accidental>ff|f|!|\?|s|ss|x)?"
    r"(?P<octave>[,']*)"
    r"(?P<duration>\d+|\\breve|\\longa)"
    r"(?P<dots>\.*)"
    r"(?P<tie>[~\(\)]|\\\(|\\\))*",
    re.IGNORECASE)


def get_key_signature(script: str) -> str:
    """Parse the \\key command and return the (relative-major) tonic.

    Scans for ``\\key <pitch> \\major`` or ``\\key <pitch> \\minor``.  If
    in a minor key, the tonic is raised by a minor third to yield the
    relative major (e.g. A minor → C, G minor → B♭).  If no ``\\key``
    command is found, defaults to ``\"C\"`` (no accidentals).

    Args:
        script: Raw LilyPond source text.

    Returns:
        The capitalised tonic note name of the key or its relative major
        (e.g. ``\"C\"``, ``\"G\"``, ``\"Bf\"``, ``\"Ef\"``).
    """
    match_obj = re.search(
        r"\\key\s+([a-g])(ff|f|s|ss|x)?\s*\\(major|minor)",
        script,
        flags=re.IGNORECASE)
    if not match_obj:
        return "C"

    tonic_letter = match_obj.group(1).lower()
    accidental = match_obj.group(2) or ""
    tonic_full = tonic_letter + accidental  # e.g. "c", "bf", "fs"
    mode = match_obj.group(3).lower()

    if mode == "minor":
        # Build reverse lookup: every name in PITCH_NAME_DICT → pitch class.
        name_to_pc: dict[str, int] = {}
        for pc, names in PITCH_NAME_DICT.items():
            for name in names:
                name_to_pc[name] = pc

        tonic_pc = name_to_pc[tonic_full]
        relative_pc = (tonic_pc + 3) % 12
        # Return the first (preferred) name of the relative major pitch
        # class (e.g. pitch class 10 → "bf" → "Bf").
        return PITCH_NAME_DICT[relative_pc][0].capitalize()

    return tonic_full.capitalize()


def _expand_abbreviations(score_code: str) -> str:
    """Expand LilyPond abbreviation notation into complete note form.

    LilyPond allows omitting the duration when it repeats the previous
    note's value: ``c'4 b b b8 b`` expands to ``c'4 b4 b4 b8 b8``.
    It also allows omitting the pitch name: ``c'4 b4 4 8 8`` expands
    to ``c'4 b4 b4 b8 b8``.  This function fills in all omitted values
    so that every note has both pitch and duration.

    The first note without a pitch defaults to middle C (``c``).  The
    first note without a duration defaults to quarter note (``4``).
    Chords (``<...>``) are not supported.

    Args:
        score_code: LilyPond note text with possible abbreviations.

    Returns:
        Score text with all abbreviations expanded to full note form.
    """
    # Encode \\volta and \\repeat volta before expansion to prevent
    # their numeric arguments from being matched as duration-only
    # abbreviated notes.
    _VOLTA_RE = re.compile(
        r"(\\repeat\s+volta\s+(\d+)|\\volta\s+(\d+(?:\s*,\s*\d+)*))")

    volta_placeholders: dict[str, str] = {}
    _alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    _counter: list[int] = [0]

    def _encode_volta(m: re.Match) -> str:
        key = f"__VOLTA_Z{_alphabet[_counter[0]]}__"
        volta_placeholders[key] = m.group(0)
        _counter[0] += 1
        return key

    score_code = _VOLTA_RE.sub(_encode_volta, score_code)

    last_pitch = "c"
    last_duration = "4"

    def _expand_match(m: re.Match) -> str:
        nonlocal last_pitch, last_duration

        pitch = m.group("pitch1")
        if pitch:
            duration = m.group("dur1")
            if duration:
                # Complete note: both pitch and duration present.
                last_pitch = pitch
                dots = m.group("dots1") or ""
                last_duration = duration + dots
                return m.group()
            else:
                # Pitch-only abbreviation: no duration, inherit previous.
                last_pitch = pitch
                return pitch + last_duration
        else:
            # Duration-only abbreviation: no pitch, inherit previous.
            duration = m.group("dur2")
            dots = m.group("dots2") or ""
            last_duration = duration + dots
            return last_pitch + last_duration

    score_code = _NOTE_EVENT_RE.sub(_expand_match, score_code)

    # Restore encoded \\volta / \\repeat volta placeholders.
    for key, original in volta_placeholders.items():
        score_code = score_code.replace(key, original)

    return score_code


def _adjust_octave_marks(score_code: str, adjustment: int) -> str:
    """Apply a uniform octave-mark shift to every pitched note.

    For ``\\fixed c'`` (adjustment = +1): each note gains one extra quote.
    For ``\\fixed c,`` (adjustment = -1): each note gains one extra comma.
    Rests are left unchanged.

    Args:
        score_code: Expanded LilyPond note text (output of
            _expand_abbreviations).
        adjustment: Octave offset to apply (octave_base_num - 3).

    Returns:
        Score text with octave marks adjusted.
    """
    if adjustment == 0:
        return score_code

    def _adjust(m: re.Match) -> str:
        pitch = m.group("pitch").lower()
        if pitch == "r":
            return m.group()  # rests have no octave marks

        octave_marks = m.group("octave") or ""
        current = -octave_marks.count(",") + octave_marks.count("'")
        new_val = current + adjustment
        if new_val >= 0:
            new_marks = "'" * new_val
        else:
            new_marks = "," * abs(new_val)

        return (m.group("pitch") +
                (m.group("accidental") or "") +
                new_marks +
                m.group("duration") +
                (m.group("dots") or "") +
                (m.group("tie") or ""))

    return _EXPANDED_NOTE_RE.sub(_adjust, score_code)


def _relative_to_absolute(score_code: str, ref_midi: int) -> str:
    """Convert relative-mode notation to absolute-mode with explicit marks.

    Simulates LilyPond's relative octave placement rule: each note is
    placed in the octave that makes the interval <= a perfect 4th
    (5 semitones) from the previous pitched note.  Rests do not
    advance the reference.

    Args:
        score_code: Expanded LilyPond note text in relative mode.
        ref_midi: MIDI number of the reference pitch (e.g. 60 for c').

    Returns:
        Score text in absolute-mode notation with explicit octave marks.
    """
    prev_midi: int = ref_midi

    def _convert(m: re.Match) -> str:
        nonlocal prev_midi

        pitch = m.group("pitch").lower()
        if pitch == "r":
            return m.group()  # rest: pass through

        # Parse accidental to numeric offset.
        accidental_str = m.group("accidental") or ""
        accidental_num = 0
        if accidental_str:
            for k, variants in ACCIDENTAL_DICT.items():
                if accidental_str.lower() in [v.lower() for v in variants]:
                    accidental_num = k
                    break

        # Get pitch class (0=C, 1=C#, ..., 11=B).
        pitch_class = 0
        for pc, names in PITCH_NAME_DICT.items():
            if pitch in names:
                pitch_class = pc
                break

        # User-specified octave marks in relative mode are extra shifts.
        octave_marks = m.group("octave") or ""
        user_shift = -octave_marks.count(",") + octave_marks.count("'")

        # Proximity-based octave placement.
        candidate_octave = prev_midi // 12
        candidate = 12 * candidate_octave + pitch_class + accidental_num
        diff = candidate - prev_midi
        if diff > 6:
            candidate_octave -= 1
            candidate = 12 * candidate_octave + pitch_class + accidental_num
        elif diff < -6:
            candidate_octave += 1
            candidate = 12 * candidate_octave + pitch_class + accidental_num

        # Apply user-specified extra octave shift.
        final_octave = candidate_octave + user_shift
        midi = 12 * final_octave + pitch_class + accidental_num
        prev_midi = midi

        # Convert MIDI to absolute-mode octave marks.
        # In absolute mode: c = MIDI 48, so octave_relative = midi//12 - 4.
        absolute_relative = (midi // 12) - 4
        if absolute_relative >= 0:
            new_marks = "'" * absolute_relative
        else:
            new_marks = "," * abs(absolute_relative)

        return (m.group("pitch") +
                (m.group("accidental") or "") +
                new_marks +
                m.group("duration") +
                (m.group("dots") or "") +
                (m.group("tie") or ""))

    return _EXPANDED_NOTE_RE.sub(_convert, score_code)


def _normalize_to_absolute(
        score_code: str,
        octave_entry_mode: str,
        octave_base_num_or_ref: int) -> str:
    """Normalize score_code so all notes carry explicit absolute-mode marks.

    For fixed and absolute modes, adjusts octave marks by a uniform
    offset.  For relative mode, simulates LilyPond's placement rule
    and emits absolute notation.

    Args:
        score_code: Expanded LilyPond note text (output of
            _expand_abbreviations).
        octave_entry_mode: One of \"fixed\", \"absolute\", \"relative\".
        octave_base_num_or_ref: For fixed/absolute, the base octave
            number (3 for absolute, 4 for \\fixed c', etc.).  For
            relative, the MIDI number of the reference pitch.

    Returns:
        Score text in absolute-mode notation with explicit octave marks.
    """
    if octave_entry_mode == "relative":
        return _relative_to_absolute(score_code, octave_base_num_or_ref)
    adjustment = octave_base_num_or_ref - 3
    if adjustment == 0:
        return score_code
    return _adjust_octave_marks(score_code, adjustment)


class BambooFlute:
    """Generates bamboo flute markup for LilyPond scores.

    Encapsulates the mapping from MIDI pitches to bamboo flute finger
    placements and jianpu notation, based on a given tonality and finger
    placement mode (筒音).
    """

    # Mapping from bamboo flute pitch number to finger hole patterns.
    # Each entry lists alternative fingerings.
    FINGER_PLACEMENT_DICT: dict[int, list[str]] = {
        0: ["one two three four five six"],
        1: ["one two three four five six1h"],
        2: ["one two three four five"],
        3: ["one two three four six",
            "one two three four five1h"],
        4: ["one two three four"],
        5: ["one two three"],
        6: ["one two four",
            "one two three1h"],
        7: ["one two"],
        8: ["one three four",
            "one two1h"],
        9: ["one"],
        10: ["two three",
             "one1h",
             "two three four"],
        11: ["",
             "three five"],
        12: ["two three four five six",
             "one two three four five six"],
        13: ["one two three four five six1h"],
        14: ["one two three four five"],
        15: ["one two three four six",
             "one two three four five1h"],
        16: ["one two three four"],
        17: ["one two three"],
        18: ["one two four",
             "one two three1h"],
        19: ["one two"],
        20: ["one three",
             "one two1h"],
        21: ["one"],
        22: ["two three four five",
             "one1h",
             "two",
             "one three four"],
        23: ["",
             "three five",
             "two three four"],
        24: ["two three four five six",
             "one two three four five six",
             "two three"],
        25: ["one two three1h four five six1h",
             "one two three1h four five six",
             "one two four six"],
        26: ["one two four five",
             "one two six"],
        27: ["one two1h five"],
        28: ["one three four six",
             "one three four five six"],
        29: ["one three six",
             "one three"],
        30: ["three"],
        31: ["two three four five"],
    }

    def __init__(
            self,
            tonality: str = "F",
            finger_placement_mode: str = "5") -> None:
        """Initialize bamboo flute configuration.

        Args:
            tonality: Concert pitch key (e.g., \"C\", \"G\", \"F\").
            finger_placement_mode: 筒音 finger mode (e.g., \"5\" means
                the lowest note is sol in jianpu).
        """
        self.tonality = tonality
        self.finger_placement_mode = finger_placement_mode
        # MIDI number of the lowest playable note for the given tonality.
        # C = MIDI 55 (G3), G = MIDI 60 (C4), etc.
        self.tube_pitch_midi_num = [
            55 + k
            for k, v in PITCH_NAME_DICT.items()
            if self.tonality.lower() in v
        ][0]
        # Build lookup: MIDI note -> bamboo flute pitch (0-31).
        midi_range = range(
            self.tube_pitch_midi_num, self.tube_pitch_midi_num + 32)
        self.pitch_num_dict: dict[int, int] = {
            midi_num: bamboo_flute_pitch_num
            for midi_num, bamboo_flute_pitch_num
            in zip(midi_range, range(32))
        }
        # Whether the previous note had an active tie (~).
        self.tie: bool = False

    def validate(self, score_code: str) -> None:
        """Validate score, stopping at the first issue found.

        Checks performed in score order:
          1. Each pitched note is within the bamboo flute's playable
             range (32 semitones above the tube pitch).
          2. Each ``\\breathe`` is immediately preceded by a pitched
             note (not by a bar line, break, or nothing).

        Args:
            score_code: LilyPond note text, already expanded and
                normalised to absolute-mode notation.
        """
        # Combined regex: match either a note+accidental+octave+duration
        # event, or a \\breathe command.
        _COMBINED_EVENT_RE = re.compile(
            r"(?P<note>"
            r"(c|d|e|f|g|a|b|r)"
            r"(ff|f|!|\?|s|ss|x)?"
            r"(,*|'*)"
            r"(\d+|\\breve|\\longa)"
            r"(\.*)"
            r"(~|\(|\)|\\\(|\\\))*"
            r")"
            r"|"
            r"(?P<breathe>\\breathe)",
            re.IGNORECASE)

        range_start = self.tube_pitch_midi_num
        range_end = range_start + 31

        for m in _COMBINED_EVENT_RE.finditer(score_code):
            if m.group("breathe"):
                # --- Check \\breathe placement ---------------------------
                before = score_code[:m.start()]
                if not re.search(
                        r"(c|d|e|f|g|a|b|r)"
                        r"(ff|f|!|\?|s|ss|x)?"
                        r"(,*|'*)"
                        r"(\d+|\\breve|\\longa)"
                        r"(\.*)"
                        r"(~|\(|\)|\\\(|\\\))*"
                        r"\s*$",
                        before, re.IGNORECASE):
                    line_num = score_code[:m.start()].count("\n") + 1
                    context = before[-40:].replace("\n", " ")
                    print(
                        f"WARNING: \\breathe at line {line_num} is not "
                        f"preceded by a note "
                        f"(context: ...{context})")
                    return
                continue

            # --- Check note range ----------------------------------------
            pitch_name = m.group(2).lower()
            if pitch_name == "r":
                continue  # rest — always in range

            accidental = m.group(3)
            accidental_num = 0
            if accidental:
                for k, v in ACCIDENTAL_DICT.items():
                    if accidental in v:
                        accidental_num = k
                        break

            octave_marks = m.group(4) or ""
            octave_relative_num = (
                -octave_marks.count(",") + octave_marks.count("'"))
            octave_num = 3 + octave_relative_num

            midi_num = (
                12 * (octave_num + 1)
                + [k for k, v in PITCH_NAME_DICT.items()
                   if pitch_name in v][0]
                + accidental_num)

            if midi_num < range_start or midi_num > range_end:
                line_num = score_code[:m.start()].count("\n") + 1
                note_text = m.group().strip()
                print(
                    f"WARNING: note {note_text} at line {line_num} "
                    f"(MIDI {midi_num}) is outside the flute's playable "
                    f"range ({range_start}-{range_end})")
                return

    def _format_jianpu_with_octave(
            self, jianpu_code: str, jianpu_octave: int) -> str:
        """Wrap jianpu text with octave dot markup.

        Args:
            jianpu_code: The jianpu number or symbol string.
            jianpu_octave: Octave index (0 = low, 1 = middle, 2+ = high).

        Returns:
            A \\center-column markup string with dots above or below.
        """
        if jianpu_octave < 1:
            # Low octave: dots below.
            dots = r" \vspace #-0.9".join(
                (1 - jianpu_octave) * [" ."])
            return (
                r"\center-column{{{0} \vspace #-0.7{1}}}"
                .format(jianpu_code, dots))
        if jianpu_octave > 1:
            # High octave: dots above.
            dots = r"\vspace #-0.9 ".join(
                (jianpu_octave - 1) * [". "])
            dots += r"\vspace #-0.3"
            vspace_offset = -(0.7 + (jianpu_octave - 2) * 0.1)
            return (
                r"\center-column{{\vspace #{:.1f} {} {}}}"
                .format(vspace_offset, dots, jianpu_code))
        # Middle octave: no dots.
        return jianpu_code

    def _format_jianpu_underline(
            self, jianpu_code: str, note_value_main: float) -> str:
        """Prepend \\underline markup for short note values.

        Args:
            jianpu_code: The jianpu text to underline.
            note_value_main: The base note value (1/duration, e.g. 1/8).

        Returns:
            The input with \\underline prefixes prepended as needed.
        """
        if note_value_main <= 0.25:
            num_underlines = int(math.log2(1 / 4 / note_value_main))
            return num_underlines * r"\underline " + jianpu_code
        return jianpu_code

    def jianpu_lyrics(
            self,
            match_obj: re.Match) -> str:
        """Generate jianpu markup for one matched note.

        Handles tie continuations (hyphens or parenthesized re-notation)
        and normal notes (full notation with octave dots and underlines).

        Args:
            match_obj: Regex match object for one note.

        Returns:
            A \\markup expression string for this note's jianpu symbol,
            with a trailing newline.
        """
        pitch_name = match_obj.group(1)

        # Parse accidental symbol to numeric offset.
        accidental = match_obj.group(2)
        if accidental:
            accidental_num = [
                k for k, v in ACCIDENTAL_DICT.items()
                if accidental in v
            ][0]
        else:
            accidental_num = 0

        # Parse octave marks (' = up, , = down).
        # All notes have been normalized to absolute mode, so:
        # octave_num = 3 + octave_relative_num.
        octave = match_obj.group(3)
        if octave:
            octave_relative_num = (
                -octave.count(",") + octave.count("'"))
        else:
            octave_relative_num = 0
        octave_num = 3 + octave_relative_num

        # Parse duration value.
        note_value_main_code = match_obj.group(4)
        if note_value_main_code.lower() == r"\longa":
            note_value_main = 4.0
        elif note_value_main_code.lower() == r"\breve":
            note_value_main = 2.0
        else:
            note_value_main = 1.0 / int(note_value_main_code)

        # Parse augmentation dots.
        note_value_dot_code = match_obj.group(5)
        if note_value_dot_code:
            note_value_dot = len(note_value_dot_code)
        else:
            note_value_dot = 0

        # Total note value in whole notes.
        note_value = note_value_main * (
            2 - 2**(-note_value_dot))

        tie_and_slur_code = match_obj.group(6)
        breathes = bool(match_obj.group(8))
        barline = bool(match_obj.group(10))

        if pitch_name.lower() == "r":
            # Rest: jianpu is always "0".
            jianpu_num = "0"
            jianpu_octave = 1
        else:
            # Convert pitch to MIDI number.
            octave_pitch = [
                12 * (octave_num + 1) + k
                for k, v in PITCH_NAME_DICT.items()
                if pitch_name.lower() in v
            ][0]
            midi_num = octave_pitch + accidental_num

            # Convert MIDI number to bamboo flute pitch.
            bamboo_flute_pitch_num = self.pitch_num_dict[midi_num]

            # Get jianpu number for this bamboo flute pitch.
            root = [
                k for k, v in JIANPU_NUM_DICT.items()
                if self.finger_placement_mode in v
            ][0]
            jianpu_num = JIANPU_NUM_DICT[
                (root + bamboo_flute_pitch_num) % 12][0]
            jianpu_octave = (
                root + bamboo_flute_pitch_num) // 12

        # Handle tie continuation across bar lines.
        if self.tie and pitch_name.lower() != "r":
            # Always re-notate with parentheses for tie continuations
            # across bar lines, regardless of duration.
            jianpu_code = "(" + jianpu_num + ")"
            jianpu_code = self._format_jianpu_underline(
                jianpu_code, note_value_main)
            jianpu_code = self._format_jianpu_with_octave(
                jianpu_code, jianpu_octave)
            if note_value_main <= 0.25:
                if note_value_dot:
                    jianpu_code += " " + note_value_dot * "."
            else:
                jianpu_code += (
                    int(note_value * 4) - 1) * "-"
        else:
            # Normal note (first of tie or no tie).
            jianpu_code = self._format_jianpu_underline(
                jianpu_num, note_value_main)
            jianpu_code = self._format_jianpu_with_octave(
                jianpu_code, jianpu_octave)
            if note_value_main <= 0.25:
                if note_value_dot:
                    jianpu_code += " " + note_value_dot * "."
            else:
                jianpu_code += (
                    int(note_value * 4) - 1) * "-"

        # Update tie state for the next note.
        self.tie = bool(tie_and_slur_code) and ("~" in tie_and_slur_code)

        breath_markup = r' \super "∨"' if breathes else ""

        jianpu_code = (
            r"\markup{{{}{}{}}}{}{}"
            .format(jianpu_code, breath_markup, barline * " |",
                    note_value_main_code, note_value_dot_code))
        return jianpu_code + "\n"

    def finger_placement_markup(
            self,
            match_obj: re.Match) -> str:
        """Generate finger diagram markup for one matched note.

        When a tie continuation is active (self.tie is True) or the
        current note is a rest, no finger markup is produced.

        Args:
            match_obj: Regex match object for one note.

        Returns:
            The note text with optional \\markup annotations appended,
            and a trailing newline or space.
        """
        # Reconstruct note_code from individual groups instead of
        # match_obj.group().strip(), because the full match may now
        # include a trailing \\breathe in group(8).
        note_code = (
            (match_obj.group(1) or "")
            + (match_obj.group(2) or "")
            + (match_obj.group(3) or "")
            + (match_obj.group(4) or "")
            + (match_obj.group(5) or "")
            + (match_obj.group(6) or "")
        )
        pitch_name = match_obj.group(1)

        # Parse accidental symbol to numeric offset.
        accidental = match_obj.group(2)
        if accidental:
            accidental_num = [
                k for k, v in ACCIDENTAL_DICT.items()
                if accidental in v
            ][0]
        else:
            accidental_num = 0

        # Parse octave marks (' = up, , = down).
        # All notes have been normalized to absolute mode, so:
        # octave_num = 3 + octave_relative_num.
        octave = match_obj.group(3)
        if octave:
            octave_relative_num = (
                -octave.count(",") + octave.count("'"))
        else:
            octave_relative_num = 0
        octave_num = 3 + octave_relative_num

        # Parse duration value.
        note_value_main_code = match_obj.group(4)
        if note_value_main_code.lower() == r"\longa":
            note_value_main = 4.0
        elif note_value_main_code.lower() == r"\breve":
            note_value_main = 2.0
        else:
            note_value_main = 1.0 / int(note_value_main_code)

        note_value_dot_code = match_obj.group(5)
        if note_value_dot_code:
            note_value_dot = len(note_value_dot_code)
        else:
            note_value_dot = 0

        note_value = note_value_main * (
            2 - 2**(-note_value_dot))
        tie_and_slur_code = match_obj.group(6)

        # Whether a \\breathe command immediately follows this note.
        breathes = bool(match_obj.group(8))

        # Skip finger markup for tie continuations and rests.
        if self.tie or (pitch_name.lower() == "r"):
            self.tie = bool(tie_and_slur_code) and ("~" in tie_and_slur_code)
            if self.tie:
                if breathes:
                    # Tie continuation has no finger diagram, so pad
                    # the breath mark with blanks to stay aligned with
                    # notes that do carry a diagram.
                    breath_mark = (
                        r'^\markup{\center-column{'
                        + '"∨" '
                        + BREATH_ALIGNMENT_BLANKS
                        + r'}}'
                    )
                    return (
                        note_code + breath_mark
                        + r" \breathe" + "\n"
                    )
                return note_code + " "
            if breathes:
                return note_code + r" \breathe" + "\n"
            return note_code + "\n"

        # octave number + pitch name -> MIDI number
        midi_num = [
            12 * (octave_num + 1) + k
            for k, v in PITCH_NAME_DICT.items()
            if pitch_name.lower() in v
        ][0] + accidental_num

        # MIDI number -> bamboo flute pitch number
        bamboo_flute_pitch_num = self.pitch_num_dict[midi_num]

        # bamboo flute pitch number + finger placement mode -> jianpu
        root = [
            k for k, v in JIANPU_NUM_DICT.items()
            if self.finger_placement_mode in v
        ][0]
        jianpu_num = JIANPU_NUM_DICT[
            (root + bamboo_flute_pitch_num) % 12][0]
        jianpu_octave = (
            root + bamboo_flute_pitch_num) // 12

        # bamboo flute pitch number -> finger placement + blow strength
        finger_placement = (
            self.FINGER_PLACEMENT_DICT[bamboo_flute_pitch_num][0])
        blow_strength = bamboo_flute_pitch_num // 12

        if breathes:
            # Combine blow strength (if any) and breath mark into one
            # markup so they sit at the same vertical position.
            # Space before ∨: 0 for 2+ blow marks, 1 for 1, 2 for none.
            if blow_strength:
                breath_spacing = "" if blow_strength >= 2 else " "
                blow_strength_markup = (
                    r'^\markup{"'
                    + "".join(blow_strength * ["+"])
                    + breath_spacing + r'∨"}'
                )
            else:
                blow_strength_markup = r'^\markup{"  ∨"}'
        else:
            if blow_strength:
                blow_strength_markup = (
                    r"^\markup{{{}}}".format(
                        "".join(blow_strength * ["+"])
                    ))
            else:
                blow_strength_markup = ""

        finger_diagram = (
            r"^\markup{{\center-column{{"
            r"\woodwind-diagram #'tin-whistle "
            r"#'((cc . ({0})) (lh . ()) (rh . ()))"
            r"}}}}").format(finger_placement)
        note_with_markup = (
            note_code + finger_diagram + blow_strength_markup)

        if breathes:
            note_with_markup += r" \breathe"

        self.tie = bool(tie_and_slur_code) and ("~" in tie_and_slur_code)
        if self.tie:
            note_with_markup += " "
        else:
            note_with_markup += "\n"
        return note_with_markup

    def get_jianpu_lyrics(
            self,
            score_code: str) -> str:
        """Process a score passage and return jianpu markup for all notes.

        Args:
            score_code: LilyPond note text between score markers, already
                normalized to absolute-mode notation.

        Returns:
            A string of \\markup expressions forming the jianpu lyrics.
        """
        self.tie = False  # reset tie state before processing
        # Convert \\volta N, M, ... to Scheme format \\volta #'(N M ...)
        # because \\lyricmode does not parse comma-separated volta numbers
        # correctly.
        score_code = re.sub(
            r"\\volta\s+(\d+(?:\s*,\s*\d+)*)",
            lambda m: (
                r"\volta #'("
                + " ".join(re.split(r"\s*,\s*", m.group(1)))
                + r")"
            ),
            score_code)
        result = re.sub(
            r"(c|d|e|f|g|a|b|r)"
            r"(ff|f|!|\?|s|ss|x)?"
            r"(,*|'*)"
            r"(\d+|\\breve|\\longa)"
            r"(\.*)"
            r"(~|\(|\)|\\\(|\\\))*"
            r"(\s*)"
            r"(\\breathe)?"
            r"(\s*)"
            r"(\||\\bar)?"
            r"(\s*)",
            self.jianpu_lyrics,
            score_code,
            flags=re.IGNORECASE)
        # Clean up any orphan \\breathe that were not consumed by the
        # note-matching regex (they are not valid in \\lyricmode).
        result = result.replace(r"\breathe", " ")
        return result

    def add_finger_placement_markup(
            self,
            score_code: str) -> str:
        """Process a score passage and add finger diagram markup.

        Also detects \\breathe commands and adds a ∨ breath-mark to the
        note immediately preceding each \\breathe.

        Args:
            score_code: LilyPond note text between score markers, already
                normalized to absolute-mode notation.

        Returns:
            Score text with \\markup\\woodwind-diagram annotations
            appended to each non-rest, non-tie-continuation note, and
            breath marks added where appropriate.
        """
        self.tie = False  # reset tie state before processing

        return re.sub(
            r"(c|d|e|f|g|a|b|r)"
            r"(ff|f|!|\?|s|ss|x)?"
            r"(,*|'*)"
            r"(\d+|\\breve|\\longa)"
            r"(\.*)"
            r"(~|\(|\)|\\\(|\\\))*"
            r"(\s*)"
            r"(\\breathe)?",
            self.finger_placement_markup,
            score_code,
            flags=re.IGNORECASE)


def _build_jianpu_block(jianpu_lyrics: str) -> str:
    """Wrap jianpu lyrics into a LilyPond variable block.

    Args:
        jianpu_lyrics: Raw jianpu \\markup expressions from
            get_jianpu_lyrics().

    Returns:
        A complete ``jianpu = \\lyricmode { ... }`` block string.
    """
    return (
        "jianpu = \\lyricmode {\n"
        + jianpu_lyrics.rstrip('\n')
        + "\n}\n"
    )


def _insert_jianpu_into_score(
        content: str, jianpu_lyrics: str) -> str:
    """Insert ``\\new Lyrics \\jianpu`` after ``} \\melody`` in the first
    ``\\score`` block.

    Handles both cases where the score block already has ``<< >>`` (the
    common case) and where it does not.

    Only the first occurrence is modified so the MIDI ``\\score`` block
    (if any) is left untouched.

    Args:
        content: Full LilyPond source text.
        jianpu_lyrics: Raw jianpu \\markup expressions from
            get_jianpu_lyrics().

    Returns:
        Content with ``\\new Lyrics \\jianpu`` inserted into the first
        display ``\\score`` block.
    """
    # Insert the jianpu variable before the first \score block.
    content = re.sub(
        r'\n(\s*\\score\s*\{)',
        lambda m: '\n\n' + _build_jianpu_block(jianpu_lyrics) + '\n'
        + m.group(1),
        content,
        count=1)

    # Insert \new Lyrics \jianpu after } \melody.
    content = re.sub(
        r'(} \\(melody)\s*\n)',
        r'\1    \\new Lyrics \\jianpu\n',
        content,
        count=1)
    return content


def _remove_midi_score(content: str) -> str:
    """Remove the MIDI-only ``\\score`` block (the one containing ``\\midi``).

    Uses brace counting from the ``\\midi`` position to find the enclosing
    ``\\score`` block, which handles nested braces in ``\\markup`` and
    ``\\with`` blocks correctly.

    Args:
        content: Full LilyPond source text.

    Returns:
        Content with the MIDI ``\\score`` block removed.
    """
    midi_pos = content.find("\\midi")
    if midi_pos == -1:
        return content

    # Search backwards for the \\score that opens before \\midi.
    score_start = content.rfind("\\score", 0, midi_pos)
    if score_start == -1:
        return content

    # Find the opening brace after \\score.
    brace_pos = content.find("{", score_start)
    if brace_pos == -1:
        return content

    # Count braces from the opening brace to find the matching close.
    depth = 1
    pos = brace_pos + 1
    while pos < len(content) and depth > 0:
        if content[pos] == "{":
            depth += 1
        elif content[pos] == "}":
            depth -= 1
        pos += 1

    # Remove from leading whitespace before \\score to the matching }.
    before_end = score_start
    while before_end > 0 and content[before_end - 1] in (" ", "\t", "\n"):
        before_end -= 1
    before = content[:before_end]
    after = content[pos:]
    return before + "\n" + after


def _strip_trailing_whitespace(content: str) -> str:
    """Strip trailing whitespace from every line.

    Args:
        content: Full LilyPond source text.

    Returns:
        Content with no trailing whitespace on any line.
    """
    return '\n'.join(line.rstrip() for line in content.split('\n')) + '\n'


if __name__ == "__main__":
    cwd = os.path.split(os.path.realpath(__file__))[0]
    src_ly = os.path.join(cwd, "testcase.ly")
    practice_ly = os.path.join(cwd, "testcase-practice.ly")
    perform_ly = os.path.join(cwd, "testcase-perform.ly")

    # ------------------------------------------------------------------ #
    # Step 1: Compile raw testcase.ly
    # ------------------------------------------------------------------ #
    print("Step 1/6: Compiling testcase.ly ...")
    try:
        subprocess.run(
            ["lilypond", src_ly],
            cwd=cwd, check=True, capture_output=True, text=True)
    except FileNotFoundError:
        sys.exit("ERROR: lilypond not found — is it installed and on PATH?")
    except subprocess.CalledProcessError as exc:
        print(exc.stderr, file=sys.stderr)
        sys.exit("ERROR: lilypond testcase.ly returned non-zero")
    print("  OK")

    # ------------------------------------------------------------------ #
    # Step 2: Generate finger-placement and jianpu markups
    # ------------------------------------------------------------------ #
    print("Step 2/6: Generating bamboo flute markup ...")
    with open(src_ly, "r", encoding="UTF-8") as f:
        script = f.read()

    tonality = get_key_signature(script)
    bf = BambooFlute(tonality, "5")
    octave_entry_mode, octave_base_num = get_octave_entry_mode(script)

    score_match = get_score_code(script)
    if not score_match:
        sys.exit(
            "ERROR: Could not find '% score begin' / '% score end' "
            "markers in input file.")
    score_code = score_match.group(1)
    score_code = _expand_abbreviations(score_code)

    # Normalize to absolute-mode notation so all downstream
    # processing assumes a single octave-entry discipline.
    score_code = _normalize_to_absolute(
        score_code, octave_entry_mode, octave_base_num)

    bf.validate(score_code)

    score_markup = bf.add_finger_placement_markup(score_code)
    jianpu_lyrics = bf.get_jianpu_lyrics(score_code)
    print("  OK")

    # ------------------------------------------------------------------ #
    # Step 3: Generate testcase-practice.ly
    # ------------------------------------------------------------------ #
    print("Step 3/6: Generating testcase-practice.ly ...")
    shutil.copy2(src_ly, practice_ly)

    with open(practice_ly, "r", encoding="UTF-8") as f:
        content = f.read()

    # Insert Ez_numbers_engraver definition before the staff-size setting.
    content = content.replace(
        "#(set-global-staff-size",
        EZ_NUMBERS_ENGRAVER_DEF + "\n\n#(set-global-staff-size")

    # Insert \textLengthOn and \easyHeadsOn before % score begin.
    content = re.sub(
        r'^(\s*)% score begin\b',
        r'\1\\textLengthOn\n\1\\easyHeadsOn\n\1% score begin',
        content,
        flags=re.MULTILINE)

    # Replace everything between % score begin and % score end.
    content = re.sub(
        r'(% score begin\n).*?(% score end)',
        lambda m: (
            m.group(1) + score_markup.rstrip('\n') + '\n' + m.group(2)),
        content,
        flags=re.DOTALL)

    # Insert jianpu variable and restructure the \score block.
    content = _insert_jianpu_into_score(content, jianpu_lyrics)

    # Replace the display \layout { } with engraver-enabled layout.
    content = re.sub(
        r'\\layout\s*\{\s*\}',
        lambda _: _LAYOUT_WITH_ENGRAVER,
        content,
        count=1)

    # Remove the MIDI \score block.
    content = _remove_midi_score(content)

    # Strip trailing whitespace.
    content = _strip_trailing_whitespace(content)

    with open(practice_ly, "w", encoding="UTF-8") as f:
        f.write(content)
    print("  OK")

    # ------------------------------------------------------------------ #
    # Step 4: Compile testcase-practice.ly
    # ------------------------------------------------------------------ #
    print("Step 4/6: Compiling testcase-practice.ly ...")
    try:
        subprocess.run(
            ["lilypond", practice_ly],
            cwd=cwd, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as exc:
        print(exc.stderr, file=sys.stderr)
        sys.exit(
            "ERROR: lilypond testcase-practice.ly returned non-zero")
    print("  OK")

    # ------------------------------------------------------------------ #
    # Step 5: Generate testcase-perform.ly
    # ------------------------------------------------------------------ #
    print("Step 5/6: Generating testcase-perform.ly ...")
    shutil.copy2(src_ly, perform_ly)

    with open(perform_ly, "r", encoding="UTF-8") as f:
        content = f.read()

    # Insert jianpu variable and restructure the \score block.
    content = _insert_jianpu_into_score(content, jianpu_lyrics)

    # Remove the MIDI \score block.
    content = _remove_midi_score(content)

    # Strip trailing whitespace.
    content = _strip_trailing_whitespace(content)

    with open(perform_ly, "w", encoding="UTF-8") as f:
        f.write(content)
    print("  OK")

    # ------------------------------------------------------------------ #
    # Step 6: Compile testcase-perform.ly
    # ------------------------------------------------------------------ #
    print("Step 6/6: Compiling testcase-perform.ly ...")
    try:
        subprocess.run(
            ["lilypond", perform_ly],
            cwd=cwd, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as exc:
        print(exc.stderr, file=sys.stderr)
        sys.exit(
            "ERROR: lilypond testcase-perform.ly returned non-zero")
    print("  OK")

    print("\nAll 6 steps completed successfully.")
    print("Open testcase-practice.pdf and testcase-perform.pdf to verify.")
