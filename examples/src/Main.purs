module Main where

import Prelude
import Effect (Effect)
import Effect.Console (logShow)
import QuickStart (unlucky)

main :: Effect Unit
main = do
  logShow $ unlucky 7
  logShow $ unlucky 13
