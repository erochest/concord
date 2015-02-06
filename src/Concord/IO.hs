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

toLines :: MonadResource m => Conduit FilePath m (Located T.Text)
toLines = do
    fp' <- await
    case fp' of
        Just fp -> sourceFile fp =$= CT.lines =$= nLines 0 fp
        Nothing -> return ()

nLines :: MonadResource m
       => Int -> FilePath -> ConduitM T.Text (Located T.Text) m ()
nLines n fp =   await
            >>= maybe (return ())
                      ( (>> nLines (n + 1) fp)
                      . yield
                      . Located fp (Line n))

-- toCorpusLines :: MonadResource m => Conduit (Located T.Text) m (Located
