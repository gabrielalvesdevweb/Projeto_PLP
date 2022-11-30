{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_time (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [1,9,3] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/gabriel/.cabal/bin"
libdir     = "/home/gabriel/.cabal/lib/x86_64-linux-ghc-8.8.4/time-1.9.3-inplace"
dynlibdir  = "/home/gabriel/.cabal/lib/x86_64-linux-ghc-8.8.4"
datadir    = "/home/gabriel/.cabal/share/x86_64-linux-ghc-8.8.4/time-1.9.3"
libexecdir = "/home/gabriel/.cabal/libexec/x86_64-linux-ghc-8.8.4/time-1.9.3"
sysconfdir = "/home/gabriel/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "time_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "time_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "time_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "time_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "time_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "time_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
