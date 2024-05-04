\version "2.24.3"
\language english

\header {
  title = "Scarborough Fair"
  subtitle = "斯卡布罗集市"
  tagline = "github.com/Chen-Jialin"
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
  \key d \major
  \time 3/4
  \tempo 4 = 120

  % score begin
  e8 b8 g8 fs8 d4 | e8 b8 g8 fs8 a4 | e8 b8 g8 d8 fs4 | e8 b8 g8 d8 a4 | e8 b8 g8 d8 fs8 e8 | e2. \breathe |
  \repeat volta 4 {
    e2 e4 | b8 b4.~ b8 b8 | fs4. g8 fs4 | e2.~ | e2. \breathe |
    r4 b4 d'4 | e'2 d'4 | b4 cs'4 a4 | b2.~ | b2.~ | b2.~ |
    b4 \breathe r4 e'4 | e'2 e'4 | d'2 b4 | b4 a4 g4 | fs4 d2~ | d2. \breathe |
    \alternative{
      \volta 1,2 {
        e2 b4 | a2 g4 | fs4 e4 d4 | e2.~ | e2.~ | e2.~ | e2 \breathe e4
      }
      \volta 3 {
        e8 b8 e8 g8 e4 | e8 b8 e8 g8 fs4 | e8 b8 e8 g8 g4 | e8 b8 e8 g8 a4 | e8 b8 e8 g8 e4 | e8 b8 e8 fs8 g8 a8 \breathe |
        b2. | b2 a4 | g4 fs2 | e2 d4 | e2.~ | e2. \breathe |
      }
      \volta 4 {
        e2 b4 | a2 g4 | fs4 e4 d4 | e2.~ | e2.~ | e2.~ | e2 \breathe r4 |
      }
    }
  }
  % score end
}

\score {
  \new Staff \with {
    instrumentName = \markup{
      \right-column{
        G调竹笛
        筒5
      }
    }
    midiInstrument = "shakuhachi"
  } \melody
  \layout { }
}
