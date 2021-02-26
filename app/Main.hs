module Main where
import Text.ParserCombinators.Parsec hiding (spaces)
import qualified Data.ByteString.Lazy.Char8 as B
import Data.Either
import System.Environment
import Data.Aeson

import Lib


d = Date 2 2 4

main :: IO ()
main = do
    (fileName:_) <- getArgs
    input <- readFile fileName
    let s = parse parseMessages "whatsapplog" input
    B.putStrLn . encode . (fromRight []) $ s

s = parse parseMessages "whatsapplog" <$> input
    where
    input = readFile "example"
