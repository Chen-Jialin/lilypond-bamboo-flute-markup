\version "2.24.3"
\language english

\header {
  title = "延音线跨小节测试"
  subtitle = ##f
  tagline = "Engraved by Jia-Lin Chen -- github.com/Chen-Jialin"
}

\paper{
  #(set-paper-size "a4")
  print-page-number = ##t
  page-number-type = #'arabic
  print-first-page-number = ##t
  first-page-number = 1
  tagline = ##f
}

#(set-global-staff-size 26)

melody = \fixed c' {
  \clef treble
  \key c \major
  \time 4/4
  \set Score.barNumberVisibility = #all-bar-numbers-visible

  \textLengthOn
  % 1. 四分音符跨一小节 (整数倍 → "-")
  c'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}^\markup{+}
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}^\markup{+}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}^\markup{+}
c'4~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}^\markup{+} |
  c'4
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}^\markup{+}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}^\markup{+}
f'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
|
  % 2. 四分音符跨两小节 (整数倍 → "-")
  g'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+ +}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
g'4~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+ +} |
  g'4
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
g'4~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+ +} |
  g'4
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
|
  % 3. 二分音符跨小节 (整数倍 → "--")
  d''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
d''2~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+ +} |
  d''2
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
|
  % 4. 附点二分音符跨小节 (整数倍 → "---")
  f'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+}f'2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+} |
  f'2.
g'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+ +}
|
  % 5. 全音符跨两小节 (整数倍 → "----")
  a'1~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two four five)) (lh . ()) (rh . ()))}}^\markup{+ +} |
  a'1
|
  % 6. 八分音符跨小节 (非整数倍 → 括号)
  b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +}
b'8~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three four six)) (lh . ()) (rh . ()))}}^\markup{+ +} |
  b'8
c''8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
|
  % 7. 附点四分音符跨小节 (非整数倍 → 括号)
  c''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
d''4.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
d''4.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+ +} |
  d''8
c''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''4.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
|
  % 8. 全音符跨三小节 (整数倍 → "----" 持续两次)
  c'1~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}^\markup{+} |
  c'1~ |
  c'1
|
  % 9. 无延音线对照 (正常标注)
  c''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
d''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
c''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one three six)) (lh . ()) (rh . ()))}}^\markup{+ +}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two four five)) (lh . ()) (rh . ()))}}^\markup{+ +}
|
}

jianpu = \lyricmode {
  % 1. 四分音符跨一小节 (整数倍 → "-")
  \markup{\center-column{\vspace #-0.7 . \vspace #-0.3 1}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 2}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 3}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 1} |}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 (1)}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 2}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 3}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 4} |}4
% 2. 四分音符跨两小节 (整数倍 → "-")
  \markup{\center-column{\vspace #-0.7 . \vspace #-0.3 5}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 6}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 7}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 5} |}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 (5)}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 6}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 7}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 5} |}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 (5)}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 6}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 7}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1} |}4
% 3. 二分音符跨小节 (整数倍 → "--")
  \markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 2}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 2}- |}2
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 (2)}-}2
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 6}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 7} |}4
% 4. 附点二分音符跨小节 (整数倍 → "---")
  \markup{\center-column{\vspace #-0.7 . \vspace #-0.3 4}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 4}-- |}2.
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 (4)}--}2.
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 5} |}4
% 5. 全音符跨两小节 (整数倍 → "----")
  \markup{\center-column{\vspace #-0.7 . \vspace #-0.3 6}--- |}1
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 (6)}--- |}1
% 6. 八分音符跨小节 (非整数倍 → 括号)
  \markup{\center-column{\vspace #-0.7 . \vspace #-0.3 7}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 7}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 7}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 \underline 7}}8
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 \underline 7} |}8
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 \underline (7)}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline 1}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline 1}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline 1}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline 1}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline 1}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline 1}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline 1} |}8
% 7. 附点四分音符跨小节 (非整数倍 → 括号)
  \markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 2} .}4.
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 2} . |}4.
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 \underline (2)}}8
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1} . |}4.
% 8. 全音符跨三小节 (整数倍 → "----" 持续两次)
  \markup{\center-column{\vspace #-0.7 . \vspace #-0.3 1}--- |}1
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 (1)}--- |}1
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 (1)}--- |}1
% 9. 无延音线对照 (正常标注)
  \markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 2}}4
\markup{\center-column{\vspace #-0.8 . \vspace #-0.9 . \vspace #-0.3 1}}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 6} |}4
}

\score {
  <<
    \new Staff \with {
      instrumentName = \markup{
        \right-column{
          C调竹笛/
          G调哨笛
          筒5
        }
      }
      midiInstrument = "acoustic grand"
    } \melody
    \new Lyrics \jianpu
  >>
  \layout { }
  \midi { }
}
