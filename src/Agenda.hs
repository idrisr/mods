module Agenda where

import Data.Time.Calendar
import Data.Time.Clock
import Data.Time.LocalTime
import Fmt
import Parser
import Data.List

getCurrentDayOfMonth :: IO Int
getCurrentDayOfMonth = do
    timeZone <- getCurrentTimeZone
    currentTime <- getCurrentTime
    let localTime = utcToLocalTime timeZone currentTime
        (_, _, day) = toGregorian $ localDay localTime
    return day

doOnDay :: Int -> [Activity] -> [Activity]
doOnDay t = filter (\x -> let m=freq x
                              d=offset x
                         in (t + d) `mod` m == 0)

today :: IO Int
today = getCurrentDayOfMonth

tomorrow :: IO Int
tomorrow = getCurrentDayOfMonth >>= \x -> pure $ x + 1

blockListG :: (Foldable f, Buildable a) => f a -> Builder
blockListG = blockListF' "- [ ]" build

printAgenda :: [Activity] -> IO ()
printAgenda as = do
    x <- today
    y <- tomorrow
    let j = doOnDay x as
    let k = doOnDay y as
    let xs = sort $ map show j
    let ys = sort $ map show k
    fmt $ "Today:\n" +| blockListG xs |+ ""
    putStrLn ""
    fmt $ "Tomorrow:\n" +| blockListG ys |+ ""
