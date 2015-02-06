{-# LANGUAGE GADTs           #-}
{-# LANGUAGE LambdaCase      #-}
{-# LANGUAGE TemplateHaskell #-}


module Concord.Types
    ( Located(..)
    , locatedIn
    , locatedAt
    , locatedData

    , LineLoc
    , CharLoc
    , SpanLoc

    , Location(..)
    , _Line
    , lineNo
    , _LineChar
    , lineChar
    , _LineSpan
    , lineSpan

    , Span(..)
    , spanStart
    , spanLength

    , Token
    , TokenSpan(..)
    , tsToken
    , tsSpan
    ) where


import           Control.Lens
import qualified Data.Text                 as T
import           Filesystem.Path.CurrentOS
import           Prelude                   hiding (FilePath)


type Token = T.Text

data Span = Span
          { _spanStart  :: !Int
          , _spanLength :: !Int
          } deriving (Show, Eq)
makeLenses ''Span

data TokenSpan = TokenSpan
               { _tsToken :: !Token
               , _tsSpan  :: !Span
               } deriving(Show)
makeLenses ''TokenSpan

data LineLoc
data CharLoc
data SpanLoc

data Location a where
        Line     :: Int         -> Location LineLoc
        LineChar :: Int -> Int  -> Location CharLoc
        LineSpan :: Int -> Span -> Location SpanLoc

instance Show (Location a) where
        show (Line l)       = "(Line " ++ show l ++ ")"
        show (LineChar l c) = "(LineChar " ++ show l ++ " " ++ show c ++ ")"
        show (LineSpan l s) = "(LineSpan " ++ show l ++ " " ++ show s ++ ")"

_Line :: Prism' (Location a) (Location a)
_Line = prism' id $ \case
                         l@Line{}     -> Just l
                         c@LineChar{} -> Nothing
                         s@LineSpan{} -> Nothing


_LineChar :: Prism' (Location a) (Location a)
_LineChar = prism' id $ \case
                             l@Line{}     -> Nothing
                             c@LineChar{} -> Just c
                             s@LineSpan{} -> Nothing

_LineSpan :: Prism' (Location a) (Location a)
_LineSpan = prism' id $ \case
                             l@Line{}     -> Nothing
                             c@LineChar{} -> Nothing
                             s@LineSpan{} -> Just s

lineNo :: Lens' (Location a) Int
lineNo f l@(Line line)       = fmap Line           (f line)
lineNo f l@(LineChar line c) = fmap (`LineChar` c) (f line)
lineNo f l@(LineSpan line s) = fmap (`LineSpan` s) (f line)

lineChar :: Lens' (Location a) Int
lineChar f l@(LineChar line c) = fmap (LineChar line) (f c)

lineSpan :: Lens' (Location a) Span
lineSpan f l@(LineSpan line s) = fmap (LineSpan line) (f s)

data Located l a = Located
               { _locatedIn   :: !FilePath
               , _locatedAt   :: !(Location l)
               , _locatedData :: !a
               } deriving (Show)
makeLenses ''Located
