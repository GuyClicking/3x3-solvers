module Move

import Data.Fin
import Data.List
import Data.Strings

public export
data Move = R  | L  | U  | D  | F  | B  |
            R2 | L2 | U2 | D2 | F2 | B2 |
            R' | L' | U' | D' | F' | B'

||| Convert a list of moves into a human readable string
export
moveString : List Move -> String
moveString xs = unwords (map moveStr xs) where
  moveStr : Move -> String
  moveStr R  = "R"
  moveStr R2 = "R2"
  moveStr R' = "R'"
  moveStr L  = "L"
  moveStr L2 = "L2"
  moveStr L' = "L'"
  moveStr U  = "U"
  moveStr U2 = "U2"
  moveStr U' = "U'"
  moveStr D  = "D"
  moveStr D2 = "D2"
  moveStr D' = "D'"
  moveStr F  = "F"
  moveStr F2 = "F2"
  moveStr F' = "F'"
  moveStr B  = "B"
  moveStr B2 = "B2"
  moveStr B' = "B'"

||| Convert an input string into a list of moves
export
parseStr : String -> List Move
parseStr x = map strMove (words x) where
  strMove : String -> Move
  strMove "R"  = R
  strMove "R2" = R2
  strMove "R'" = R'
  strMove "L"  = L
  strMove "L2" = L2
  strMove "L'" = L'
  strMove "U"  = U
  strMove "U2" = U2
  strMove "U'" = U'
  strMove "D"  = D
  strMove "D2" = D2
  strMove "D'" = D'
  strMove "F"  = F
  strMove "F2" = F2
  strMove "F'" = F'
  strMove "B"  = B
  strMove "B2" = B2
  strMove "B'" = B'
  strMove x = R
