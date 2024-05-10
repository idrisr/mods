module Parser where

import Control.Applicative
import Data.Maybe
import Text.Trifecta

data Activity = Activity
    { freq :: Int
    , offset :: Int
    , desc :: String
    }
    deriving Eq

instance Show Activity where
    show (Activity _ _ s) = s

commentLine :: Parser ()
commentLine = string "--" *> skipMany (noneOf "\n") *> newline *> pure ()

-- doesnt seem right to use a maybe here
-- dont signal failure outside of the parser failure constructor
parserActivity :: Parser (Maybe Activity)
parserActivity =
    Just <$> do
        n <- integer
        m <- integer
        t <- manyTill anyChar newline
        let f = fromIntegral
        return $ Activity (f n) (f m) t

entryParser :: Parser (Maybe Activity)
{- hlint ignore: "Use $>" -}
entryParser = try parserActivity <|> (commentLine *> pure Nothing)

parserFile :: Parser [Maybe Activity]
parserFile = some entryParser

-- Parse a file containing both comment and entry lines
parseFile :: FilePath -> IO [Activity]
parseFile filePath = do
    contents <- readFile filePath
    case parseString parserFile mempty contents of
        Success result -> return $ catMaybes result
        Failure e -> error $ show e
