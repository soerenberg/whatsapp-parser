module Main where
import Text.ParserCombinators.Parsec hiding (spaces)
import System.Environment
import Control.Monad

import Lib


main :: IO ()
main = do
    (fileName:_) <- getArgs
    input <- readFile fileName
    putStrLn input
    let s = parse parseMessages "whatsapplog" input
    putStrLn $ show s
