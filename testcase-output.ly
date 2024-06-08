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

\textLengthOn
  e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
d8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
fs4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
d8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
d8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe |
  \repeat volta 4 {
    e2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
b4.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| fs4.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe |
    r4b4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
| e'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
| b4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
cs'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . ()) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| b2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
|
    b4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
\breathe r4e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
| e'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
| d'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
b4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| fs4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
d2~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| d2.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
\breathe |
    \alternative{
      \volta 1,2 {
        e2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| a2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| fs4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe e4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
}
      \volta 3 {
        e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
a8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
\breathe |
        b2.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| g4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe |
      }
      \volta 4 {
        e2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| a2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| fs4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe r4|
      }
    }
  }
}

jianpu = \lyricmode {
  \markup{\center-column{\vspace #-0.7 . \vspace #-0.3 \underline 6}}8
\markup{\underline 3}8
\markup{\underline 1}8
\markup{\center-column{\underline 7 \vspace #-0.7 .}}8
\markup{\center-column{5 \vspace #-0.7 .}}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\underline 1}8
\markup{\center-column{\underline 7 \vspace #-0.7 .}}8
\markup{2}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\underline 1}8
\markup{\center-column{\underline 5 \vspace #-0.7 .}}8
\markup{\center-column{7 \vspace #-0.7 .}}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\underline 1}8
\markup{\center-column{\underline 5 \vspace #-0.7 .}}8
\markup{2}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\underline 1}8
\markup{\center-column{\underline 5 \vspace #-0.7 .}}8
\markup{\center-column{\underline 7 \vspace #-0.7 .}}8
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\repeat volta 4 {
    \markup{\center-column{6 \vspace #-0.7 .}-}2
\markup{\center-column{6 \vspace #-0.7 .}}4
\markup{\underline 3}8
\markup{3 .}4.
\markup{\underline 3}8
\markup{\underline 3}8
\markup{\center-column{7 \vspace #-0.7 .} .}4.
\markup{\underline 1}8
\markup{\center-column{7 \vspace #-0.7 .}}4
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{0}4
\markup{3}4
\markup{5}4
\markup{6-}2
\markup{5}4
\markup{3}4
\markup{♯4}4
\markup{2}4
\markup{3--}2.
\markup{3--}2.
\markup{3--}2.
\markup{3}4
\markup{0}4
\markup{6}4
\markup{6-}2
\markup{6}4
\markup{5-}2
\markup{3}4
\markup{3}4
\markup{2}4
\markup{1}4
\markup{\center-column{7 \vspace #-0.7 .}}4
\markup{\center-column{5 \vspace #-0.7 .}-}2
\markup{\center-column{5 \vspace #-0.7 .}--}2.
\alternative{
      \volta 1 {
        \markup{\center-column{6 \vspace #-0.7 .}-}2
\markup{3}4
\markup{2-}2
\markup{1}4
\markup{\center-column{7 \vspace #-0.7 .}}4
\markup{\center-column{6 \vspace #-0.7 .}}4
\markup{\center-column{5 \vspace #-0.7 .}}4
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}-}2
\markup{\center-column{6 \vspace #-0.7 .}}4
}
      \volta 3 {
        \markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 1}8
\markup{\center-column{6 \vspace #-0.7 .}}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 1}8
\markup{\center-column{7 \vspace #-0.7 .}}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 1}8
\markup{1}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 1}8
\markup{2}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 1}8
\markup{\center-column{6 \vspace #-0.7 .}}4
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\underline 3}8
\markup{\center-column{\underline 6 \vspace #-0.7 .}}8
\markup{\center-column{\underline 7 \vspace #-0.7 .}}8
\markup{\underline 1}8
\markup{\underline 2}8
\markup{3--}2.
\markup{3-}2
\markup{2}4
\markup{1}4
\markup{\center-column{7 \vspace #-0.7 .}-}2
\markup{\center-column{6 \vspace #-0.7 .}-}2
\markup{\center-column{5 \vspace #-0.7 .}}4
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}--}2.
}
      \volta 4 {
        \markup{\center-column{6 \vspace #-0.7 .}-}2
\markup{3}4
\markup{2-}2
\markup{1}4
\markup{\center-column{7 \vspace #-0.7 .}}4
\markup{\center-column{6 \vspace #-0.7 .}}4
\markup{\center-column{5 \vspace #-0.7 .}}4
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}--}2.
\markup{\center-column{6 \vspace #-0.7 .}-}2
\markup{0}4
}
    }
  }
}

\score {
  <<
  \new Staff \with {
    instrumentName = \markup{
      \right-column{
        G调竹笛
        筒5
      }
    }
    midiInstrument = "shakuhachi"
  } \melody
  \new Lyrics { \jianpu }
  >>
  % \layout { }
}
