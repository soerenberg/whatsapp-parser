module Lib
( Date
, Time
, Message
, parseMessage
, parseMessages
) where

import Text.ParserCombinators.Parsec hiding (spaces)
import Text.Parsec.Prim hiding (try)

import Control.Monad


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
    , sender :: String
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

parseHeader :: Parser (Date, Time, String)
parseHeader = do
    startOfLine
    date <- lexeme parseDate
    lexeme $ char ','
    time <- lexeme parseTime
    void <- lexeme $ char '-'
    sender <- manyTill anyChar $ lexeme $ char ':'
    return (date, time, sender)

headerAhead :: Parser ()
headerAhead = lookAhead parseHeader *> return ()

parseBody :: Parser String
parseBody = manyTill anyChar $ eof <|> headerAhead

parseMessage :: Parser Message
parseMessage = do
    (d, t, s) <- parseHeader
    b <- parseBody
    return Message { date = d
                   , time = t
                   , sender = s
                   , body = b}

parseMessages :: Parser [Message]
parseMessages = many parseMessage
