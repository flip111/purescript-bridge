{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}


module MyLib (main) where

import Prelude

import           Control.Lens (view)
import           Control.Monad.IO.Class (liftIO)
import           Data.Aeson
import qualified Data.Aeson.Encode.Pretty as AP
import qualified Data.ByteString.Lazy.Char8 as Char8
import           Data.Text (pack, unpack)
import           GHC.Generics
import           GHC.TypeLits
import           Network.Wai.Handler.Warp
import           Servant
import           System.Environment (lookupEnv)

import Types
    (Bar (Bar), Foo (Foo), barMessage, barNumber, fooMessage, fooNumber)

type FooServer
  = "foo" :> (Get '[JSON] Foo
              :<|> ReqBody '[JSON] Foo :> Post '[JSON] NoContent
             )

type BarServer
  = "bar" :> (Get '[JSON] Bar
              :<|> ReqBody '[JSON] Bar :> Post '[JSON] NoContent
             )

foo :: Foo
foo = Foo (pack "Hello") 123

fooServer :: Server FooServer
fooServer = getFoo :<|> postFoo
  where
    getFoo = return foo
    postFoo foo = do
      let
        logMsg = "Foo message: " <> (unpack $ view fooMessage foo)
          <> "\t Foo number: " <> (show (view fooNumber foo))
      liftIO . putStrLn $ logMsg
      return NoContent

bar :: Bar
bar = Bar (pack "Hello") 123

barServer :: Server BarServer
barServer = getBar :<|> postBar
  where
    getBar = return bar
    postBar bar = do
      let
        logMsg = "Bar message: " <> (unpack $ view barMessage bar)
          <> "\t Bar number: " <> (show (view barNumber bar))
      liftIO . putStrLn $ logMsg
      return NoContent

staticServer :: Server Raw
staticServer = serveDirectoryWebApp "static"

type ExampleServer = FooServer :<|> BarServer :<|> Raw

api :: Proxy ExampleServer
api = Proxy

main :: IO ()
main = do
  putStrLn "Serving Foo:"
  Char8.putStrLn $ AP.encodePretty foo
  putStrLn "and Bar:"
  Char8.putStrLn $ AP.encodePretty bar

  run 8080 . serve api $ fooServer :<|> barServer :<|> staticServer
