module Main where

import Prelude

import Data.Argonaut.Aeson.Decode.Generic (genericDecodeAeson)
import Data.Argonaut.Aeson.Encode.Generic (genericEncodeAeson)
import Data.Argonaut.Aeson.Options (Options(Options), SumEncoding(TaggedObject), defaultOptions)
import Data.Either (Either(Left, Right))
import Data.Maybe (Maybe(Just))
import Data.Lens (over, view, set)
import Data.Traversable (for_)
import Effect (Effect)
import Effect.Console (log)
import Effect.Class (liftEffect)
import Effect.Aff (launchAff_)
import Affjax (get, post_)
import Affjax.ResponseFormat (json)
import Affjax.RequestBody as RequestBody

import Types (Foo, fooMessage, fooNumber, Bar(Bar), barMessage, barNumber)

main :: Effect Unit
main = log "Hello, Purescript!" *> launchAff_ do
  -- "Foo" tests untagged JSON, i.e.:
  -- { "_fooMessage": "Hello", "_fooNumber": 123 }

  -- request a Foo
  fooResponse <- get json "/foo"
  for_ fooResponse \fooPayload -> do
    let
      efoo :: Either String Foo
      efoo = genericDecodeAeson defaultOptions fooPayload.body
    case efoo of
      Left e -> liftEffect $ log $ "Error decoding Foo: " <> e
      Right _ -> pure unit
    for_ efoo \foo -> do
      liftEffect do
        log $ "Foo message: " <> (view fooMessage foo)
          <> "\t Foo number: " <> (show $ view fooNumber foo)
      let
        -- modify the Foo received and send it back
        foo' = set fooMessage "Hola" $ over fooNumber (_+1) foo
        response = Just $ RequestBody.json $ genericEncodeAeson defaultOptions foo'
      post_ "/foo" response

  let

    defaultOptionsWithTagSingleConstructors :: Options
    defaultOptionsWithTagSingleConstructors = Options
      { sumEncoding: TaggedObject { tagFieldName: "tag", contentsFieldName: "contents" }
      , tagSingleConstructors: true
      , allNullaryToStringTag: false
      }

  -- "Bar" tests tagged JSON, i.e.:
  -- {
  --   "contents": {
  --       "message": "Hello",
  --       "number": 123
  --   },
  --   "tag": "bar"
  -- }

  -- send a Bar to the server
  let
    outboundBar = Bar { _barMessage: "Hello", _barNumber: 789}
    outboundBarEncoded = genericEncodeAeson defaultOptionsWithTagSingleConstructors outboundBar
    response' = Just $ RequestBody.json outboundBarEncoded
  void $ post_ "/bar" response'
  -- This is serialized to:
  -- {"_barNumber":789,"_barMessage":"Hello","tag":"Bar"}
  -- The server rejects the request.

  -- request a Bar
  barResponse <- get json "/bar"
  for_ barResponse \barPayload -> do
    let
      ebar :: Either String Bar
      ebar = genericDecodeAeson defaultOptionsWithTagSingleConstructors barPayload.body
    case ebar of
      -- An error is thrown, here.  The server's Bar is:
      -- {
      --   "contents": {
      --       "message": "Hello",
      --       "number": 123
      --   },
      --   "tag": "bar"
      -- }
      Left e -> liftEffect $ log $ "Error decoding Bar: " <> e
      Right _ -> pure unit
    for_ ebar \bar -> do
      liftEffect do
        log $ "Bar message: " <> (view barMessage bar)
          <> "\t Bar number: " <> (show $ view barNumber bar)
      let
        -- modify the Bar received and send it back
        bar' = set barMessage "Hola" $ over barNumber (_+1) bar
        response = Just $ RequestBody.json $ genericEncodeAeson defaultOptionsWithTagSingleConstructors bar'
      post_ "/bar" response
