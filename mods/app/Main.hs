module Main where

import Agenda
import Parser
import System.FilePath

main :: IO ()
main = do
    activities <- parseFile $ "/home" </> "hippoid" </> "fun" </> "mods" </> "content"
    printAgenda activities
