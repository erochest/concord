{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}


module Concord.IO
    ( walkCorpus
    , toLines
    -- , toCorpusLines
    ) where


import           Conduit
import           Control.Applicative
import           Control.Monad
import qualified Data.Conduit.Text         as CT
import qualified Data.Text                 as T
import qualified Data.Text.Lazy            as TL
import           Filesystem.Path.CurrentOS
import           Prelude                   hiding (FilePath)

import           Concord.Types


walkCorpus :: MonadResource m => FilePath -> Producer m FilePath
walkCorpus = sourceDirectoryDeep True

toLines :: MonadResource m => Conduit FilePath m (Located LineLoc T.Text)
toLines = do
    fp' <- await
    case fp' of
        Just fp -> sourceFile fp =$= CT.lines =$= locateLines fp
        Nothing -> return ()

locateLines :: MonadResource m
            => FilePath -> ConduitM T.Text (Located LineLoc T.Text) m ()
locateLines fp = go 1
    where
        go n =   await
             >>= maybe (return ())
                       ( (>> go (n + 1))
                       . yield
                       . Located fp (Line n))

-- toCorpusLines :: MonadResource m => Conduit (Located T.Text) m (Located
