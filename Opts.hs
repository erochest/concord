{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}


module Opts
    ( execParser
    , opts
    ) where


import           ClassyPrelude
import           Data.Version
import           Options.Applicative

import           Paths_concord
import           Types


opts' :: Parser ConcordOpts
opts' =   CO
      <$> fpOption (  short 'i' ++ long "input" ++ metavar "DIRECTORY"
                   ++ help "The input directory.")
      <*> optional (fpOption (  short 'o' ++ long "output" ++ metavar "FILENAME"
                             ++ help "The output file. The default is to\
                                     \ write to STDOUT."))

opts :: ParserInfo ConcordOpts
opts = info (helper <*> opts')
            (  fullDesc
            ++ progDesc "Generate a concordance from a directory of text files."
            ++ header (  "concord v" ++ showVersion version
                      ++ " - Generate concordances"))

fpOption :: Mod OptionFields FilePath -> Parser FilePath
fpOption = option (fpFromString <$> str)
