{-# LANGUAGE OverloadedStrings #-}

module Database where

import Database.SQLite.Simple
import Types

-- | Connect to the SQLite database
connectDB :: IO Connection
connectDB = open "inventory.db"

-- | Create the inventory table if it doesn't exist
createTable :: Connection -> IO ()
createTable conn =
  execute_ conn
    "CREATE TABLE IF NOT EXISTS inventory \
    \(id INTEGER PRIMARY KEY, name TEXT, quantity INT, price REAL, spoilage INT)"

-- | Add a new item to the database
addItemDB :: Connection -> Item -> IO ()
addItemDB conn item =
  execute conn
    "INSERT INTO inventory (name, quantity, price, spoilage) VALUES (?, ?, ?, ?)"
    item

-- | Delete an item by id
deleteItemDB :: Connection -> Int -> IO ()
deleteItemDB conn itemId =
  execute conn "DELETE FROM inventory WHERE id = ?" (Only itemId)

-- | Update an existing item
updateItemDB :: Connection -> Item -> IO ()
updateItemDB conn (Item id name qty price spoil) =
  execute conn
    "UPDATE inventory SET name=?, quantity=?, price=?, spoilage=? WHERE id=?"
    (name, qty, price, spoil, id)

-- | Get all items from the database
getAllItems :: Connection -> IO [Item]
getAllItems conn =
  query_ conn "SELECT id, name, quantity, price, spoilage FROM inventory"