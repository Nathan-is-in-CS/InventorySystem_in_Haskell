{-# LANGUAGE OverloadedStrings #-}

module Database where

import Database.SQLite.Simple
import Types

connectDB :: IO Connection
connectDB = open "inventory.db"

createTable :: Connection -> IO ()
createTable conn =
  execute_ conn
    "CREATE TABLE IF NOT EXISTS inventory \
    \(id INTEGER PRIMARY KEY, name TEXT, quantity INTEGER, price REAL, spoilage INTEGER)"

-- Fixed: uses withTransaction so changes are properly committed
addItemDB :: Connection -> Item -> IO ()
addItemDB conn item =
  withTransaction conn $
    execute conn
      "INSERT INTO inventory (name, quantity, price, spoilage) VALUES (?, ?, ?, ?)"
      item

deleteItemDB :: Connection -> Int -> IO ()
deleteItemDB conn itemId =
  withTransaction conn $
    execute conn "DELETE FROM inventory WHERE id = ?" (Only itemId)

updateItemDB :: Connection -> Item -> IO ()
updateItemDB conn (Item id name qty price spoil) =
  withTransaction conn $
    execute conn
      "UPDATE inventory SET name=?, quantity=?, price=?, spoilage=? WHERE id=?"
      (name, qty, price, spoil, id)

getAllItems :: Connection -> IO [Item]
getAllItems conn =
  query_ conn "SELECT id, name, quantity, price, spoilage FROM inventory"