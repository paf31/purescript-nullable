-- | This module defines types and functions for working with nullable types
-- | using the FFI.

module Data.Nullable
  ( Nullable
  , isoNullableMaybe
  , toMaybe
  , toNullable
  ) where

import Prelude

import Data.Function (on)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Iso (Iso(Iso))
import Data.Maybe (Maybe(..), maybe)

-- | A nullable type.
-- |
-- | This type constructor may be useful when interoperating with JavaScript functions
-- | which accept or return null values.
foreign import data Nullable :: * -> *

-- | The null value.
foreign import null :: forall a. Nullable a

foreign import nullable :: forall a r. Fn3 (Nullable a) r (a -> r) r

-- | Wrap a non-null value.
foreign import notNull :: forall a. a -> Nullable a

-- | Takes `Nothing` to `null`, and `Just a` to `a`.
toNullable :: forall a. Maybe a -> Nullable a
toNullable = maybe null notNull

-- | Represent `null` using `Maybe a` as `Nothing`.
toMaybe :: forall a. Nullable a -> Maybe a
toMaybe n = runFn3 nullable n Nothing Just

isoNullableMaybe :: forall a. Iso (Nullable a) (Maybe a)
isoNullableMaybe = Iso toMaybe toNullable

instance showNullable :: Show a => Show (Nullable a) where
  show = maybe "null" show <<< toMaybe

instance eqNullable :: (Eq a) => Eq (Nullable a) where
  eq = eq `on` toMaybe

instance ordNullable :: (Ord a) => Ord (Nullable a) where
  compare = compare `on` toMaybe
