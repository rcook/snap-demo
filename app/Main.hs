{-|
Module      : Main
Description : Main module
Copyright   : (C) Richard Cook, 2018
Licence     : MIT
Maintainer  : rcook@rcook.org
Stability   : stable
Portability : portable

This is the first sample from <http://snapframework.com/docs/tutorials/snap-api>
with some @import@s and @LANGUAGE@ pragmas.
-}

{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Applicative
import Snap.Core
import Snap.Http.Server
import Snap.Util.FileServe

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , ("echo/:echoparam", echoHandler)
          ] <|>
    dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param
