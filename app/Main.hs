{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           CodeWorld.Auth
                    ( AuthConfig
                    , authMethod
                    , authRoutes
                    , getAuthConfig
                    , optionallyAuthenticated
                    )
import           CodeWorld.Auth.Http (ok200Json)
import           CodeWorld.Auth.Util (m)
import qualified Data.ByteString.Char8 as Char8 (unpack)
import           Snap.Core
                    ( Method(..)
                    , Snap
                    , getParam
                    , method
                    , route
                    )
import           Snap.Http.Server (quickHttpServe)
import           Snap.Util.FileServe (serveFile)
import           System.Directory (getCurrentDirectory)

main :: IO ()
main = do
    cwd <- getCurrentDirectory
    authConfig <- getAuthConfig cwd
    putStrLn $ "Authentication: " ++ authMethod authConfig
    quickHttpServe (site authConfig)

site :: AuthConfig -> Snap ()
site authConfig = route $
    [ ("app", method GET (serveFile "app.html"))
    , ("command0", method POST (command0Handler authConfig))
    ] ++ authRoutes authConfig

command0Handler :: AuthConfig -> Snap ()
command0Handler = optionallyAuthenticated $ \_ -> do
    Just x <- getParam "x"
    Just y <- getParam "y"
    ok200Json $ m [ ("result", Char8.unpack x ++ Char8.unpack y) ]
