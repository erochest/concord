{-# LANGUAGE TemplateHaskell #-}


module Concord.Types
    ( Located(..)
    , locatedIn
    , locatedAt
    , locatedData

    , Location(..)
    , _Line
    , lineNo
    , _LineChar
    , lineChar
    ) where


import           Control.Lens
import           Filesystem.Path.CurrentOS
import           Prelude                   hiding (FilePath)


data Location
        = Line     { _lineNo :: !Int
                   }
        | LineChar { _lineNo   :: !Int
                   , _lineChar :: !Int
                   }
        deriving (Show)
makePrisms ''Location
makeLenses ''Location

data Located a = Located
               { _locatedIn   :: !FilePath
               , _locatedAt   :: !Location
               , _locatedData :: !a
               } deriving (Show)
makeLenses ''Located
