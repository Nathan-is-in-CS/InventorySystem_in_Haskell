{-# LANGUAGE OverloadedStrings #-}

module Types (Item(..)) where

import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.ToRow

-- | Item data type
data Item = Item
  { itemId    :: Int
  , itemName  :: String
  , quantity  :: Int
  , price     :: Double
  , spoilage  :: Int
  } deriving (Show)

-- | Convert a database row into an Item
instance FromRow Item where
  fromRow = Item <$> field <*> field <*> field <*> field <*> field

-- | Convert an Item into a database row (for insert/update)
instance ToRow Item where
  toRow (Item _ name qty price spoil) =
    toRow (name, qty, price, spoil)