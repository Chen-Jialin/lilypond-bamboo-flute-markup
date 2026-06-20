\version "2.24.3"
\language english

\header {
  title = "Scarborough Fair"
  subtitle = "斯卡布罗集市"
  copyright = ""
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

#(define Ez_numbers_engraver
   (make-engraver
    (acknowledgers
     ((note-head-interface engraver grob source-engraver)
      (let* ((context (ly:translator-context engraver))
       (tonic-pitch (ly:context-property context 'tonic))
       (tonic-name (ly:pitch-notename tonic-pitch))
       (grob-pitch
        (ly:event-property (event-cause grob) 'pitch))
       (grob-name (ly:pitch-notename grob-pitch))
       (delta (modulo (- grob-name tonic-name) 7))
       (note-names
        (make-vector 7 (number->string (1+ delta)))))
  (ly:grob-set-property! grob 'note-names note-names))))))

#(set-global-staff-size 26)

melody = \fixed c' {
  \clef treble
  \key d \major
  \time 3/4
  \tempo 4 = 120
  \set Score.barNumberVisibility = #all-bar-numbers-visible

  \textLengthOn

  \easyHeadsOn

  % score begin

  e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
fs'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
fs'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
d'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
d'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
d'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
fs'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e'2.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}^\markup{"  ∨"} \breathe
 \break |
  \repeat volta 4 {
    e'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
b'4.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+} b'8
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
| fs'4.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
fs'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| e'2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}} | e'2. \breathe
 \break |
    r4
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
d''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}^\markup{+}
| e''2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}^\markup{+}
d''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}^\markup{+}
| b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
cs''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four)) (lh . ()) (rh . ()))}}^\markup{+}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
| b'2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+} | b'2.~ | b'2.~ | b'4 \breathe
 \break
    r4
e''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}^\markup{+}
| e''2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}^\markup{+}
e''4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}^\markup{+}
| d''2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}^\markup{+}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
| b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
g'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
| fs'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
d'2~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}} | d'2. \breathe
 \break |
    \alternative{
      \volta 1,2 {
        e'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
| a'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
g'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
| fs'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| e'2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}} | e'2.~ | e'2.~ | e'2 \breathe
 e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
\break
      }
      \volta 3 {
        e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
fs'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
g'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
| e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
e'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
fs'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
g'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
a'8^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{"+ ∨"} \breathe
 \break |
        b'2.^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
| b'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
a'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
| g'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
fs'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
| e'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| e'2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}} | e'2. \breathe
 \break |
      }
      \volta 4 {
        e'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
b'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three four five)) (lh . ()) (rh . ()))}}^\markup{+}
| a'2^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three four five six)) (lh . ()) (rh . ()))}}^\markup{+}
g'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (two three)) (lh . ()) (rh . ()))}}
| fs'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one)) (lh . ()) (rh . ()))}}
e'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}}
d'4^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two three)) (lh . ()) (rh . ()))}}
| e'2.~^\markup{\center-column{\woodwind-diagram #'tin-whistle #'((cc . (one two)) (lh . ()) (rh . ()))}} | e'2.~ | e'2.~ | e'2 \breathe
 r4
|
      }
    }
  }

% score end
}

lyric = \lyricmode{
  \skip2.*6 |
  <<
    {
      Are2 you4 | go8 -- ing2 to8 | Scar4. -- bo8 -- rough4 | Fair?2.*2 |
      \skip4 Par4 -- sley,4 | sa2 -- ge,4 | rose4 -- mary,4 and4 | thyme;2.*3 | \skip4
      \skip4 Re4 -- | mem2 -- ber4 | me2 to4 | one4 who4 lives4 | the4 -- re,1 \skip4 |
    }
    \new Lyrics{
      him2 to4 | make8 me2 a8 | cam4. -- br8 -- ic4 | shirt,2.*2 |
      \skip4 Par4 -- sley,4 | sa2 -- ge,4 | rose4 -- mary,4 and4 | thyme;2.*3 | \skip4
      \skip4 With4 -- | out2 no4 | seams2 nor4 | nee2 -- dle4 | work,2.*2
    }
    \new Lyrics{
      him2 to4 | find8 me2 a8 | a4. -- cre8 of4 | land,2.*2 |
      \skip4 Par4 -- sley,4 | sa2 -- ge,4 | rose4 -- mary,4 and4 | thyme;2.*3 | \skip4
      \skip4 Be4 -- | tween2 the4 | salt2 water4 | and4 the4 sea4 | strand,2.*2
    }
    \new Lyrics{
      "Tell him"2 to4 | reap8 it4. with8 a8 | si4. -- ckle8 of4 | leather,2.*2 |
      \skip4 Par4 -- sley,4 | sa2 -- ge,4 | rose4 -- mary,4 and4 | thyme;2.*3 | \skip4
      \skip4 And4 | gather2 it4 | all2 in4 | a4 bunch4 of4 | heather,2.*2
    }
  >>
  <<
    {He2 was4 | once2 the4 | true4 love4 of4 | mine.2.*3 | \skip2 Tell4}
    \new Lyrics{
      Then2 "he'll"4 | be2 a4 | true4 love4 of4 | mine.2.*3 | \skip2 Tell4
    }
  >>
  \skip2.*6 |
  Then2. | "he'll"2 be4 | a4 true2 | love2 of4 | mine.2.*2 |
  Then2 "he'll"4 | be2 a4 | true4 love4 of4 | mine.2.*3
}

jianpu = \lyricmode {

  \markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 4}8
\markup{\underline 3}8
\markup{1 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 4}8
\markup{\underline 3}8
\markup{5 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 4}8
\markup{\underline 1}8
\markup{3 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 4}8
\markup{\underline 1}8
\markup{5 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 4}8
\markup{\underline 1}8
\markup{\underline 3}8
\markup{\underline 2 |}8
\markup{2-- \super "∨"}2.
\break |
  \repeat volta 4 {
    \markup{2-}2
\markup{2 |}4
\markup{\underline 6}8
\markup{6 .}4.
\markup{\underline (6)}8
\markup{\underline 6 |}8
\markup{3 .}4.
\markup{\underline 4}8
\markup{3 |}4
\markup{2-- |}2.
\markup{(2)-- \super "∨"}2.
\break |
    \markup{0}4
\markup{6}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 1} |}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 2}-}2
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 1} |}4
\markup{6}4
\markup{7}4
\markup{5 |}4
\markup{6-- |}2.
\markup{(6)-- |}2.
\markup{(6)-- |}2.
\markup{(6) \super "∨"}4
\break
    \markup{0}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 2} |}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 2}-}2
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 2} |}4
\markup{\center-column{\vspace #-0.7 . \vspace #-0.3 1}-}2
\markup{6 |}4
\markup{6}4
\markup{5}4
\markup{4 |}4
\markup{3}4
\markup{1- |}2
\markup{(1)-- \super "∨"}2.
\break |
    \alternative{
      \volta #'(1 2) {
        \markup{2-}2
\markup{6 |}4
\markup{5-}2
\markup{4 |}4
\markup{3}4
\markup{2}4
\markup{1 |}4
\markup{2-- |}2.
\markup{(2)-- |}2.
\markup{(2)-- |}2.
\markup{(2)- \super "∨"}2
\markup{2}4
\break
      }
      \volta #'(3) {
        \markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 2}8
\markup{\underline 4}8
\markup{2 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 2}8
\markup{\underline 4}8
\markup{3 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 2}8
\markup{\underline 4}8
\markup{4 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 2}8
\markup{\underline 4}8
\markup{5 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 2}8
\markup{\underline 4}8
\markup{2 |}4
\markup{\underline 2}8
\markup{\underline 6}8
\markup{\underline 2}8
\markup{\underline 3}8
\markup{\underline 4}8
\markup{\underline 5 \super "∨"}8
\break |
        \markup{6-- |}2.
\markup{6-}2
\markup{5 |}4
\markup{4}4
\markup{3- |}2
\markup{2-}2
\markup{1 |}4
\markup{2-- |}2.
\markup{(2)-- \super "∨"}2.
\break |
      }
      \volta #'(4) {
        \markup{2-}2
\markup{6 |}4
\markup{5-}2
\markup{4 |}4
\markup{3}4
\markup{2}4
\markup{1 |}4
\markup{2-- |}2.
\markup{(2)-- |}2.
\markup{(2)-- |}2.
\markup{(2)- \super "∨"}2
\markup{0 |}4
}
    }
  }

}


\score {
  <<
    \new Staff \with {
      instrumentName = \markup{
        \right-column{
          G调竹笛/
          D调哨笛
          筒5
        }
      }
    } \melody
    \new Lyrics \jianpu
    \new Lyrics \lyric
  >>
  \layout {
    \context {
      \Voice
      \consists \Ez_numbers_engraver
    }
  }
}


