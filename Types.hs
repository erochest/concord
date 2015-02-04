{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}


module Types
    ( ConcordOpts(..)
    ) where


import           Control.Lens

import           ClassyPrelude


data ConcordOpts
        = CO
        { _optsInput  :: !FilePath
        , _optsOutput :: !(Maybe FilePath)
        } deriving (Show)
makeLenses ''ConcordOpts
