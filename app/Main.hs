module Main where
import Text.ParserCombinators.Parsec hiding (spaces)
import Text.Parsec.Prim hiding (try)
import System.Environment
import Control.Monad

import Lib

data Date = Date
    { day :: Int
    , month :: Int
    , year :: Int
    } deriving (Eq, Show)

data Time = Time
    { hour :: Int
    , minute :: Int
    } deriving (Eq, Show)

data Message = Message
    { date :: Date
    , time :: Time
    , body :: String
    } deriving (Eq, Show)

whitespace :: Parser String
whitespace = many $ oneOf " \n\t"

lexeme :: Parser a -> Parser a
lexeme p = do
    x <- p
    whitespace
    return x

startOfLine :: Monad m => ParsecT s u m ()
startOfLine = do
    pos <- getPosition
    guard (sourceColumn pos == 1)

parseDate :: Parser Date
parseDate = do
    month <- read <$> many1 digit
    char '/'
    day <- read <$> many1 digit
    char '/'
    year <- read <$> many1 digit
    return Date { day=day, month=month, year= 2000 + year }


parseTime :: Parser Time
parseTime = do
    hour <- read <$> many1 digit
    char ':'
    minute <- read <$> many digit
    return Time {hour = hour, minute = minute}

parseHeader :: Parser (Date, Time)
parseHeader = do
    startOfLine
    date <- lexeme parseDate
    lexeme $ char ','
    time <- lexeme parseTime
    return (date, time)

parseBody :: Parser String
parseBody = manyTill anyChar (char '#') -- parseHeader  -- TODO eof?

parseMessage :: Parser Message
parseMessage = do
    (d, t) <- parseHeader
    b <- parseBody
    char '\n'
    return Message {date = d, time = t, body = b}

parseMessages :: Parser [Message]
parseMessages = many parseMessage

main :: IO ()
main = do
    (fileName:_) <- getArgs
    input <- readFile fileName
    let s = parse parseMessages "wa" input
    putStrLn $ show s
