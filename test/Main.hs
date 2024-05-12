module Main (main) where

import ParserTest
import Test.Tasty

tests :: TestTree
tests =
    testGroup
        ""
        [ parseTests
        ]

main :: IO ()
main = defaultMain tests
