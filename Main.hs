{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}


module Main where


import           ClassyPrelude
import           Conduit
import           Data.Conduit
import           Filesystem

import           Concord.IO
import           Concord.Types

import           Opts
import           Types


main :: IO ()
main = do
    CO inputDir outputFile <- execParser opts
    let output = maybe (stdoutC :: Consumer String (ResourceT IO) ())
                       sinkFile
                       outputFile
    absInput <- canonicalizePath inputDir
    runResourceT $  walkCorpus absInput
                 $= toLines
                 $$ mapC show
                 =$ unlinesC
                 =$ output
