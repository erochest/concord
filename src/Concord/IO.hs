{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}


module Concord.IO
    ( walkCorpus
    ) where


import           Conduit
import           Filesystem.Path.CurrentOS
import           Prelude                   hiding (FilePath)


walkCorpus :: MonadResource m => FilePath -> Producer m FilePath
walkCorpus = sourceDirectoryDeep True
