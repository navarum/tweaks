## Changes to bsdgames tetris

- Don't sleep when "eliding" full rows

- Don't ask if user wants to see scores

- Keep track of statistics like total time, number of rotations, etc. and output them to a file

  (The last change is for gathering additional data that may be of use in psychology experiments)

      $ tetris -o stats.out
      ...
      $ cat stats.out
      Time: 7.0
      Paused: 0.0
      Rotations: 4
      Right trans: 6
      Left trans: 4
      Drops: 3
      Score: 51
      Level: 2
