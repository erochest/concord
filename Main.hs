{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}


module Main where


import           ClassyPrelude

import           Opts
import           Types


main :: IO ()
main = print =<< execParser opts
