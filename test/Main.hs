module Main (main) where

import Test.Tasty
import ParserTest

tests :: TestTree
tests = testGroup "" [
    parseTests
    ]

main :: IO ()
main = defaultMain tests
