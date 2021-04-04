module Main

import Move
import System.REPL

solveScrambleString : String -> String
solveScrambleString x = moveString (parseStr x) ++ "\n"

main : IO ()
main = repl "Scramble: " solveScrambleString
