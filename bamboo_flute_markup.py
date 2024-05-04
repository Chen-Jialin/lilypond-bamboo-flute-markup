import os
import re
import math

# mapping relations
pitch_name_dict = {0: ["c"], 2: ["d"], 4: ["e"], 5: ["f"], 7: ["g"], 9: ["a"], 11: ["b"]}
accidental_dict = {-2: ["ff", "-flatflat", "𝄫"], -1: ["f", "-flat", "♭"], 0: ["!", "?", "♮"], 1: ["s", "-sharp", "♯"], 2: ["ss", "x", "-sharpsharp", "𝄪"]}
jianpu_num_dict = {0: ["1"], 1: ["♯1", "♭2", "♯1/♭2"], 2: ["2"], 3: ["♯2", "♭3", "♯2/♭3"], 4: ["3"], 5: ["4"], 6: ["♯4", "♭5", "♯4/♭5"], 7: ["5"], 8: ["♯5", "♭6", "♯5/♭6"], 9: ["6"], 10: ["♯6", "♭7", "♯6/♭7"], 11: ["7"]}

def get_octave_entry_mode(script):
    octave_base_num = 3
    match_obj = re.search(r"\\fixed\s*(c|d|e|f|g|a|b)(ff|f|s|ss|x)?(,*|'*)\s*\{", script, flags=re.I)
    if match_obj:
        octave = match_obj.group(3)
        if octave:
            octave_base_num += -octave.count(",") + octave.count("'")
        return "fixed", octave_base_num
    match_obj = re.search(r"\\relative\s*\{", script, flags=re.I)
    if match_obj:
        return "relative", octave_base_num
    return "absolute", octave_base_num

def get_score_code(script):
    match_obj = re.search(r"%\s*score\s*begin(.*)%\s*score\s*end", script, re.I|re.S)
    if not match_obj:
        print("Score code not found.")
    return match_obj

class bamboo_flute:
    finger_placement_dict = {0: ["one two three four five six"],
                             1: ["one two three four five six1h"],
                             2: ["one two three four five"],
                             3: ["one two three four six", "one two three four five1h"],
                             4: ["one two three four"],
                             5: ["one two three"],
                             6: ["one two four", "one two three1h"],
                             7: ["one two"],
                             8: ["one three four", "one two1h"],
                             9: ["one"],
                             10: ["two three", "one1h", "two three four"],
                             11: ["", "three five"],
                             12: ["two three four five six", "one two three four five six"],
                             13: ["one two three four five six1h"],
                             14: ["one two three four five"],
                             15: ["one two three four six", "one two three four five1h"],
                             16: ["one two three four"],
                             17: ["one two three"],
                             18: ["one two four", "one two three1h"],
                             19: ["one two"],
                             20: ["one three", "one two1h"],
                             21: ["one"],
                             22: ["two three four five", "one1h", "two", "one three four"],
                             23: ["", "three five", "two three four"],
                             24: ["two three four five six", "one two three four five six", "two three"],
                             25: ["one two three1h four five six1h", "one two three1h four five six", "one two four six"],
                             26: ["one two four five", "one two six"],
                             27: ["one two1h five"],
                             28: ["one three four six", "one three four five six"],
                             29: ["one three six", "one three"],
                             30: ["three"],
                             31: ["two three four five"]}

    def __init__(self, tonality="F", finger_placement_mode="5"):
        self.tonality = tonality
        self.finger_placement_mode = finger_placement_mode
        self.tube_pitch_midi_num = [55 + k for k, v in pitch_name_dict.items() if self.tonality.lower() in v][0]
        self.pitch_num_dict = {midi_num: bamboo_flute_pitch_num for midi_num, bamboo_flute_pitch_num in zip(range(self.tube_pitch_midi_num, self.tube_pitch_midi_num + 32), range(32))}

    def markup(self, match_obj, octave_entry_mode="absolute", octave_base_num=3, markup_mode="practice"):
        note_code = match_obj.group().strip()
        pitch_name = match_obj.group(1)
        accidental = match_obj.group(2)
        if accidental:
            accidental_num = [k for k, v in accidental_dict.items() if accidental in v][0]
        else:
            accidental_num = 0
        octave = match_obj.group(3)
        if octave:
            octave_relative_num = -octave.count(",") + octave.count("'")
        else:
            octave_relative_num = 0
        if octave_entry_mode.lower() == "relative":
            # TODO
            pass
        else:
            if octave_entry_mode.lower() != "fixed":
                octave_entry_mode = "absolute"
                octave_base_num = 3
            octave_num = octave_base_num + octave_relative_num
        note_value_main_code = match_obj.group(4)
        if note_value_main_code.lower() == r"\longa":
            note_value_main = 4
        elif note_value_main_code.lower() == r"\breve":
            note_value_main = 2
        else:
            note_value_main = 1 / int(note_value_main_code)
        dot_code = match_obj.group(5)
        if dot_code:
            note_value_dot = len(dot_code)
        else:
            note_value_dot = 0
        note_value = note_value_main * (2 - 2**(-note_value_dot))

        if pitch_name.lower() == "r":
            jianpu_num = "0"
            jianpu_octave = 0
            blow_strength = 0
            finger_placement = ""
        else:
            # octave number + pitch name -> MIDI number
            midi_num = [12 * (octave_num + 1) + k for k, v in pitch_name_dict.items() if pitch_name.lower() in v][0] + accidental_num

            # MIDI number -> bamboo flute pitch number
            bamboo_flute_pitch_num = self.pitch_num_dict[midi_num]

            # bamboo flute pitch number + finger placement mode -> jianpu
            jianpu_num = jianpu_num_dict[([k for k, v in jianpu_num_dict.items() if self.finger_placement_mode in v][0] + bamboo_flute_pitch_num) % 12][0]
            jianpu_octave = ([k for k, v in jianpu_num_dict.items() if self.finger_placement_mode in v][0] + bamboo_flute_pitch_num) // 12

            # bamboo flute pitch number -> finger placement + blow strength
            finger_placement = self.finger_placement_dict[bamboo_flute_pitch_num][0]
            blow_strength = bamboo_flute_pitch_num // 12

        # finger placement + blow strength + jianpu -> markup
        if note_value_main <= 1/4:
            jianpu_code = int(math.log2(1 / 4 / note_value_main)) * r"\underline " + jianpu_num
            if note_value_dot != 0:
                jianpu_code = r"\line{" + jianpu_code + " " + note_value_dot * "." + "}"
        else:
            jianpu_code = jianpu_num + (int(note_value * 4) - 1) * "-"
        if jianpu_octave == 0:
            jianpu_code = jianpu_code + r" \vspace #-0.6 ."
        else:
            jianpu_code = (jianpu_octave - 1) * r"\vspace #-0.5 . " + jianpu_code + r' \vspace #-0.6 " "'
        jianpu_code += r" \vspace #0.1"
        blow_strength_code = blow_strength * "+ "
        finger_placement_code = r" \woodwind-diagram #'tin-whistle #'((cc . ({})) (lh . ()) (rh . ()))".format(finger_placement)

        if markup_mode == "performance":
            note_with_markup_code = r"{}^\markup{{\center-column{{{}}}}}".format(note_code, jianpu_code)
        else:
            note_with_markup_code = r"{}^\markup{{\center-column{{{}{}{}}}}}".format(note_code, blow_strength_code, jianpu_code, finger_placement_code)
            note_with_markup_code += "\n"
        return note_with_markup_code

    def add_markup(self, score_code, octave_entry_mode="absolute", octave_base_num=3, markup_mode="practice"):
        score_with_markup_code = re.sub(r"(c|d|e|f|g|a|b|r)(ff|f|!|\?|s|ss|x)?(,*|'*)(\d+|\\breve|\\longa)(\.*)(~|\(|\)|\\\(|\\\))*(\s*)", lambda match_obj: self.markup(match_obj, octave_entry_mode, octave_base_num, markup_mode), score_code, flags=re.I)
        return score_with_markup_code

if __name__ == "__main__":
    cwd = os.path.split(os.path.realpath(__file__))[0]
    file_name = "testcase.ly"
    file_path = os.path.join(cwd, file_name)
    file_name_new = "testcase-output.ly"
    file_path_new = os.path.join(cwd, file_name_new)
    if os.path.exists(file_path_new):
        if not re.match(r"\s*y\s*", input("Warning: file already exists. Continue to overwrite? [y|N]"), re.I):
            exit()
    bf = bamboo_flute("G", "5")
    with open(file_path, "r", encoding="UTF-8") as f:
        script = f.read()
        score_code_match_obj = get_score_code(script)
        score_with_markup_code = bf.add_markup(score_code_match_obj.group(1), octave_entry_mode="fixed", octave_base_num=4, markup_mode="practice")
        score_with_markup_code = r"\textLengthOn" + score_with_markup_code
        script_new = script.replace(score_code_match_obj.group(), score_with_markup_code)
        with open(file_path_new, "w", encoding="UTF-8") as f_new:
            f_new.write(script_new)
