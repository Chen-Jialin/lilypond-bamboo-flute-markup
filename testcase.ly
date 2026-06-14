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

% score begin
  % 1. 四分音符跨一小节 (整数倍 → "-")
  c'4 d'4 e'4 c'4~ |
  c'4 d'4 e'4 f'4 |
  % 2. 四分音符跨两小节 (整数倍 → "-")
  g'4 a'4 b'4 g'4~ |
  g'4 a'4 b'4 g'4~ |
  g'4 a'4 b'4 c''4 |
  % 3. 二分音符跨小节 (整数倍 → "--")
  d''4 c''4 d''2~ |
  d''2 a'4 b'4 |
  % 4. 附点二分音符跨小节 (整数倍 → "---")
  f'4 f'2.~ |
  f'2. g'4 |
  % 5. 全音符跨两小节 (整数倍 → "----")
  a'1~ |
  a'1 |
  % 6. 八分音符跨小节 (非整数倍 → 括号)
  b'4 b'4 b'4 b'8 b'8~ |
  b'8 c''8 c''8 c''8 c''8 c''8 c''8 c''8 |
  % 7. 附点四分音符跨小节 (非整数倍 → 括号)
  c''4 d''4. d''4.~ |
  d''8 c''4 c''4 c''4. |
  % 8. 全音符跨三小节 (整数倍 → "----" 持续两次)
  c'1~ |
  c'1~ |
  c'1 |
  % 9. 无延音线对照 (正常标注)
  c''4 d''4 c''4 a'4 |
% score end
}

\score {
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
  \layout { }
  \midi { }
}
