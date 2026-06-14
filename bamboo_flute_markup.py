"""Add bamboo flute markup to LilyPond scores.

Parses LilyPond .ly files and generates finger placement diagrams and
jianpu (numbered musical notation) lyrics for bamboo flute.
"""

import math
import os
import re
from typing import Optional

# Mapping from pitch class to pitch name strings used in LilyPond.
PITCH_NAME_DICT: dict[int, list[str]] = {
    0: ["c"],
    2: ["d"],
    4: ["e"],
    5: ["f"],
    7: ["g"],
    9: ["a"],
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


def get_octave_entry_mode(script: str) -> tuple[str, int]:
    """Detect octave entry mode and base octave number from a LilyPond script.

    Scans for \\fixed, \\relative, or defaults to absolute mode.

    Args:
        script: Raw LilyPond source text.

    Returns:
        A tuple of (mode, base_octave_number), where mode is one of
        \"fixed\", \"relative\", or \"absolute\".
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
    match_obj = re.search(r"\\relative\s*\{", script, flags=re.IGNORECASE)
    if match_obj:
        return "relative", octave_base_num
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
            match_obj: re.Match,
            octave_entry_mode: str = "absolute",
            octave_base_num: int = 3) -> str:
        """Generate jianpu markup for one matched note.

        Handles tie continuations (hyphens or parenthesized re-notation)
        and normal notes (full notation with octave dots and underlines).

        Args:
            match_obj: Regex match object for one note.
            octave_entry_mode: \"fixed\", \"relative\", or \"absolute\".
            octave_base_num: Base octave number for absolute/fixed modes.

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
        octave = match_obj.group(3)
        if octave:
            octave_relative_num = (
                -octave.count(",") + octave.count("'"))
        else:
            octave_relative_num = 0

        if octave_entry_mode.lower() == "relative":
            # TODO: relative mode not yet implemented.
            octave_num = 0  # placeholder
        else:
            if octave_entry_mode.lower() != "fixed":
                octave_entry_mode = "absolute"
                octave_base_num = 3
            octave_num = octave_base_num + octave_relative_num

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
        barline = bool(match_obj.group(8))

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

        jianpu_code = (
            r"\markup{{{}{}}}{}{}"
            .format(jianpu_code, barline * " |",
                    note_value_main_code, note_value_dot_code))
        return jianpu_code + "\n"

    def finger_placement_markup(
            self,
            match_obj: re.Match,
            octave_entry_mode: str = "absolute",
            octave_base_num: int = 3) -> str:
        """Generate finger diagram markup for one matched note.

        When a tie continuation is active (self.tie is True) or the
        current note is a rest, no finger markup is produced.

        Args:
            match_obj: Regex match object for one note.
            octave_entry_mode: \"fixed\", \"relative\", or \"absolute\".
            octave_base_num: Base octave number for absolute/fixed modes.

        Returns:
            The note text with optional \\markup annotations appended,
            and a trailing newline or space.
        """
        note_code = match_obj.group().strip()
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
        octave = match_obj.group(3)
        if octave:
            octave_relative_num = (
                -octave.count(",") + octave.count("'"))
        else:
            octave_relative_num = 0

        if octave_entry_mode.lower() == "relative":
            # TODO: relative mode not yet implemented.
            pass
        else:
            if octave_entry_mode.lower() != "fixed":
                octave_entry_mode = "absolute"
                octave_base_num = 3
            octave_num = octave_base_num + octave_relative_num

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

        # Skip finger markup for tie continuations and rests.
        if self.tie or (pitch_name.lower() == "r"):
            self.tie = bool(tie_and_slur_code) and ("~" in tie_and_slur_code)
            if self.tie:
                return note_code + " "
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

        if blow_strength:
            blow_strength_markup = (
                r"^\markup{{{}}}".format(
                    " ".join(blow_strength * ["+"])
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

        self.tie = bool(tie_and_slur_code) and ("~" in tie_and_slur_code)
        if self.tie:
            note_with_markup += " "
        else:
            note_with_markup += "\n"
        return note_with_markup

    def get_jianpu_lyrics(
            self,
            score_code: str,
            octave_entry_mode: str = "absolute",
            octave_base_num: int = 3) -> str:
        """Process a score passage and return jianpu markup for all notes.

        Args:
            score_code: LilyPond note text between score markers.
            octave_entry_mode: \"fixed\", \"relative\", or \"absolute\".
            octave_base_num: Base octave number for absolute/fixed modes.

        Returns:
            A string of \\markup expressions forming the jianpu lyrics.
        """
        self.tie = False  # reset tie state before processing
        # remove breathe code
        score_code = score_code.replace(r"\breathe", " ")
        # remove extra volta number
        score_code = re.sub(
            r"(\\volta\s+\d*)(\s*,\s*\d*)*",
            r"\1",
            score_code)
        return re.sub(
            r"(c|d|e|f|g|a|b|r)"
            r"(ff|f|!|\?|s|ss|x)?"
            r"(,*|'*)"
            r"(\d+|\\breve|\\longa)"
            r"(\.*)"
            r"(~|\(|\)|\\\(|\\\))*"
            r"(\s*)"
            r"(\||\\bar)?"
            r"(\s*)",
            lambda m: self.jianpu_lyrics(
                m, octave_entry_mode, octave_base_num),
            score_code,
            flags=re.IGNORECASE)

    def add_finger_placement_markup(
            self,
            score_code: str,
            octave_entry_mode: str = "absolute",
            octave_base_num: int = 3) -> str:
        """Process a score passage and add finger diagram markup.

        Args:
            score_code: LilyPond note text between score markers.
            octave_entry_mode: \"fixed\", \"relative\", or \"absolute\".
            octave_base_num: Base octave number for absolute/fixed modes.

        Returns:
            Score text with \\markup\\woodwind-diagram annotations
            appended to each non-rest, non-tie-continuation note.
        """
        self.tie = False  # reset tie state before processing
        return re.sub(
            r"(c|d|e|f|g|a|b|r)"
            r"(ff|f|!|\?|s|ss|x)?"
            r"(,*|'*)"
            r"(\d+|\\breve|\\longa)"
            r"(\.*)"
            r"(~|\(|\)|\\\(|\\\))*"
            r"(\s*)",
            lambda m: self.finger_placement_markup(
                m, octave_entry_mode, octave_base_num),
            score_code,
            flags=re.IGNORECASE)


if __name__ == "__main__":
    cwd = os.path.split(os.path.realpath(__file__))[0]
    file_name = "testcase.ly"
    file_path = os.path.join(cwd, file_name)
    bf = BambooFlute("C", "5")
    with open(file_path, "r", encoding="UTF-8") as f:
        script = f.read()
        octave_entry_mode, octave_base_num = get_octave_entry_mode(script)
        score_code_match_obj = get_score_code(script)
        if not score_code_match_obj:
            raise SystemExit(
                "Error: Could not find '% score begin' / '% score end' "
                "markers in input file.")
        score_with_markup = bf.add_finger_placement_markup(
            score_code_match_obj.group(1),
            octave_entry_mode=octave_entry_mode,
            octave_base_num=octave_base_num)
        score_with_markup = r"\textLengthOn" + score_with_markup
        print(score_with_markup)
        jianpu_lyrics = bf.get_jianpu_lyrics(
            score_code_match_obj.group(1),
            octave_entry_mode=octave_entry_mode,
            octave_base_num=octave_base_num)
        print(jianpu_lyrics)
