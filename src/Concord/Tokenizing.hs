{-# LANGUAGE OverloadedStrings #-}


module Concord.Tokenizing
    ( tokenize
    , tokenize'
    , tokenizeLines
    ) where


import           Conduit
import qualified Data.Text                 as T
import           Filesystem.Path.CurrentOS
import           Prelude                   hiding (FilePath)

import           Concord.Types


tokenize :: Monad m => Conduit T.Text m [TokenSpan]
tokenize = undefined

tokenize' :: T.Text -> [TokenSpan]
tokenize' = undefined

tokenizeLines :: Monad m
              => Conduit (Located LineLoc T.Text) m (Located SpanLoc Token)
tokenizeLines = undefined
