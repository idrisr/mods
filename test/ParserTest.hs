{-# LANGUAGE QuasiQuotes #-}

module ParserTest where

import Parser
import Test.Tasty
import Test.Tasty.HUnit
import Text.Trifecta
import Text.RawString.QQ

parseTests :: TestTree
parseTests =
    testGroup
        "Parse"
        [ lineTests
        , commentTests
        , fileTests
        ]

p :: Parser a -> String -> Result a
p = flip parseString mempty

maybeSuccess :: Result a -> Maybe a
maybeSuccess (Success a) = Just a
maybeSuccess (Failure _) = Nothing

maybeSuccess1 :: Result (Maybe a) -> Maybe a
maybeSuccess1 (Success (Just a)) = Just a
maybeSuccess1 _ = Nothing

lineTests :: TestTree
lineTests =
    testGroup
        "Activity"
        [ let sut = "3 0 cardio meta\n"
              got = p parserActivity sut
              wot = Just $ Activity 3 0 "cardio meta"
           in testCase "" $ wot @=? maybeSuccess1 got
        , let sut = "--3 0 cardio meta\n"
              got = p parserActivity sut
              wot = Nothing
           in testCase "" $ wot @=? maybeSuccess1 got
        , let sut = "3 -11 cardio\n"
              got = p parserActivity sut
              wot = Just $ Activity 3 (-11) "cardio"
           in testCase "" $ wot @=? maybeSuccess1 got
        ]

commentTests :: TestTree
commentTests =
    testGroup
        "Comment"
        [ let sut = "--3 0 cardio meta"
              got = p parserActivity sut
              wot = Nothing
           in testCase "" $ wot @=? maybeSuccess got
        ]

fileTests :: TestTree
fileTests =
    testGroup
        "File"
        [ let sut = file
              got = p parserFile sut
              wot =
                [ Just $ Activity 3 1 "mods"
                , Nothing
                , Just $ Activity 5 1 "wardrobe"
                , Nothing
                ]
           in testCase "" $ Just wot @=? maybeSuccess got
        ]

file :: String
file =
    [r|3 1 mods
-- 5 0 automata
5 1 wardrobe
--  5 2 terraform
|]
