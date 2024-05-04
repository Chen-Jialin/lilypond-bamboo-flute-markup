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
  e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\underline 7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{5 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\underline 7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{2 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
d8^\markup{\center-column{\underline 5 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
fs4^\markup{\center-column{7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
d8^\markup{\center-column{\underline 5 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{2 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
d8^\markup{\center-column{\underline 5 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\underline 7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe |
  \repeat volta 4 {
    e2^\markup{\center-column{6- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
b4.~^\markup{\center-column{\line{3 .} \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| fs4.^\markup{\center-column{\line{7 .} \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs4^\markup{\center-column{7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe |
    r4^\markup{\center-column{0 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . ()) (lh . ()) (rh . ()))}}
b4^\markup{\center-column{3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
d'4^\markup{\center-column{+ 5 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}
| e'2^\markup{\center-column{+ 6- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
d'4^\markup{\center-column{+ 5 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}
| b4^\markup{\center-column{3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
cs'4^\markup{\center-column{♯4 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . ()) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{2 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| b2.~^\markup{\center-column{3-- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b2.~^\markup{\center-column{3-- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b2.~^\markup{\center-column{3-- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
|
    b4^\markup{\center-column{3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
\breathe r4^\markup{\center-column{0 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . ()) (lh . ()) (rh . ()))}}
e'4^\markup{\center-column{+ 6 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e'2^\markup{\center-column{+ 6- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
e'4^\markup{\center-column{+ 6 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| d'2^\markup{\center-column{+ 5- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}
b4^\markup{\center-column{3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b4^\markup{\center-column{3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{2 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| fs4^\markup{\center-column{7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
d2~^\markup{\center-column{5- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| d2.^\markup{\center-column{5-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
\breathe |
    \alternative{
      \volta 1,2 {
        e2^\markup{\center-column{6- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b4^\markup{\center-column{3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| a2^\markup{\center-column{2- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| fs4^\markup{\center-column{7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{5 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2^\markup{\center-column{6- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe e4^\markup{\center-column{6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
}
      \volta 3 {
        e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs4^\markup{\center-column{7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{2 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b8^\markup{\center-column{\underline 3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e8^\markup{\center-column{\underline 6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
fs8^\markup{\center-column{\underline 7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
g8^\markup{\center-column{\underline 1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
a8^\markup{\center-column{\underline 2 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
\breathe |
        b2.^\markup{\center-column{3-- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| b2^\markup{\center-column{3- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
a4^\markup{\center-column{2 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| g4^\markup{\center-column{1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs2^\markup{\center-column{7- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
| e2^\markup{\center-column{6- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{5 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe |
      }
      \volta 4 {
        e2^\markup{\center-column{6- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
b4^\markup{\center-column{3 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| a2^\markup{\center-column{2- \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g4^\markup{\center-column{1 \vspace #-0.6 " " \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| fs4^\markup{\center-column{7 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}
e4^\markup{\center-column{6 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
d4^\markup{\center-column{5 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five six)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2.~^\markup{\center-column{6-- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
| e2^\markup{\center-column{6- \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}
\breathe r4^\markup{\center-column{0 \vspace #-0.6 . \vspace #0.1 \woodwind-diagram #'tin-whistle #'((cc . ()) (lh . ()) (rh . ()))}}
|
      }
    }
  }
  
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
