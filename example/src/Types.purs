-- File auto generated by purescript-bridge! --
module Types where

import Prelude

import Control.Lazy (defer)
import Data.Argonaut.Aeson.Decode.Generic (genericDecodeAeson)
import Data.Argonaut.Aeson.Encode.Generic (genericEncodeAeson)
import Data.Argonaut.Aeson.Options (defaultOptions) as Argonaut
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Class (class DecodeJson, class DecodeJsonField, decodeJson)
import Data.Argonaut.Decode.Class as Argonaut
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Class as Argonaut
import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Lens (Iso', Lens', Prism', iso, lens, prism')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Record (prop)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Show.Generic (genericShow)
import Foreign.Object (Object)
import Type.Proxy (Proxy(Proxy))

newtype Baz = Baz { _bazMessage :: String }



instance Show Baz where
  show a = genericShow a

instance EncodeJson Baz where
  encodeJson = defer \_ -> genericEncodeAeson Argonaut.defaultOptions

instance DecodeJson Baz where
  decodeJson = defer \_ -> genericDecodeAeson Argonaut.defaultOptions

derive instance Generic Baz _

derive instance Newtype Baz _

--------------------------------------------------------------------------------

_Baz :: Iso' Baz {_bazMessage :: String}
_Baz = _Newtype

bazMessage :: Lens' Baz String
bazMessage = _Newtype <<< prop (Proxy :: _"_bazMessage")

--------------------------------------------------------------------------------

newtype Foo = Foo
  { _fooMessage :: String
  , _fooNumber :: Int
  , _fooList :: Array Int
  , _fooMap :: Object Int
  , _fooBaz :: Baz
  , _fooTestData :: TestData
  , _fooTestSum :: TestSum
  }



instance Show Foo where
  show a = genericShow a

instance EncodeJson Foo where
  encodeJson = defer \_ -> genericEncodeAeson Argonaut.defaultOptions

instance DecodeJson Foo where
  decodeJson = defer \_ -> genericDecodeAeson Argonaut.defaultOptions

derive instance Generic Foo _

derive instance Newtype Foo _

--------------------------------------------------------------------------------

_Foo :: Iso' Foo {_fooMessage :: String, _fooNumber :: Int, _fooList :: Array Int, _fooMap :: Object Int, _fooBaz :: Baz, _fooTestData :: TestData, _fooTestSum :: TestSum}
_Foo = _Newtype

fooMessage :: Lens' Foo String
fooMessage = _Newtype <<< prop (Proxy :: _"_fooMessage")

fooNumber :: Lens' Foo Int
fooNumber = _Newtype <<< prop (Proxy :: _"_fooNumber")

fooList :: Lens' Foo (Array Int)
fooList = _Newtype <<< prop (Proxy :: _"_fooList")

fooMap :: Lens' Foo (Object Int)
fooMap = _Newtype <<< prop (Proxy :: _"_fooMap")

fooBaz :: Lens' Foo Baz
fooBaz = _Newtype <<< prop (Proxy :: _"_fooBaz")

fooTestData :: Lens' Foo TestData
fooTestData = _Newtype <<< prop (Proxy :: _"_fooTestData")

fooTestSum :: Lens' Foo TestSum
fooTestSum = _Newtype <<< prop (Proxy :: _"_fooTestSum")

--------------------------------------------------------------------------------

newtype Bar a = Bar a



instance (Show a) => Show (Bar a) where
  show a = genericShow a

instance (EncodeJson a) => EncodeJson (Bar a) where
  encodeJson = defer \_ -> genericEncodeAeson Argonaut.defaultOptions

instance (DecodeJson a, DecodeJsonField a) => DecodeJson (Bar a) where
  decodeJson = defer \_ -> genericDecodeAeson Argonaut.defaultOptions

derive instance Generic (Bar a) _

derive instance Newtype (Bar a) _

--------------------------------------------------------------------------------

_Bar :: forall a. Iso' (Bar a) a
_Bar = _Newtype

--------------------------------------------------------------------------------

data TestSum
  = Nullary
  | Bool Boolean
  | Int Int
  | Number Number



instance Show TestSum where
  show a = genericShow a

instance EncodeJson TestSum where
  encodeJson = defer \_ -> genericEncodeAeson Argonaut.defaultOptions

instance DecodeJson TestSum where
  decodeJson = defer \_ -> genericDecodeAeson Argonaut.defaultOptions

derive instance Generic TestSum _

--------------------------------------------------------------------------------

_Nullary :: Prism' TestSum Unit
_Nullary = prism' (const Nullary) case _ of
  Nullary -> Just unit
  _ -> Nothing

_Bool :: Prism' TestSum Boolean
_Bool = prism' Bool case _ of
  (Bool a) -> Just a
  _ -> Nothing

_Int :: Prism' TestSum Int
_Int = prism' Int case _ of
  (Int a) -> Just a
  _ -> Nothing

_Number :: Prism' TestSum Number
_Number = prism' Number case _ of
  (Number a) -> Just a
  _ -> Nothing

--------------------------------------------------------------------------------

data TestData
  = Maybe (Maybe TestSum)
  | Either (Either (Maybe Int) (Maybe Boolean))



instance Show TestData where
  show a = genericShow a

instance EncodeJson TestData where
  encodeJson = defer \_ -> genericEncodeAeson Argonaut.defaultOptions

instance DecodeJson TestData where
  decodeJson = defer \_ -> genericDecodeAeson Argonaut.defaultOptions

derive instance Generic TestData _

--------------------------------------------------------------------------------

_Maybe :: Prism' TestData (Maybe TestSum)
_Maybe = prism' Maybe case _ of
  (Maybe a) -> Just a
  _ -> Nothing

_Either :: Prism' TestData (Either (Maybe Int) (Maybe Boolean))
_Either = prism' Either case _ of
  (Either a) -> Just a
  _ -> Nothing
