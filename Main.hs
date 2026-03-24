import Database
import Inventory
import Types
import Database.SQLite.Simple

main :: IO ()
main = do
  conn <- connectDB
  createTable conn
  menuLoop conn

menuLoop :: Connection -> IO ()
menuLoop conn = do
  putStrLn "\nInventory System"
  putStrLn "1. Add Item"
  putStrLn "2. Delete Item"
  putStrLn "3. View Items"
  putStrLn "4. Compute Totals"
  putStrLn "5. Exit"
  putStr "Choice: "
  choice <- getLine
  handleChoice conn choice

handleChoice :: Connection -> String -> IO ()
handleChoice conn "1" = do
  putStrLn "Name:"
  name <- getLine
  putStrLn "Quantity:"
  qty <- readLn
  putStrLn "Price:"
  price <- readLn
  putStrLn "Spoilage:"
  spoil <- readLn
  addItemDB conn (Item 0 name qty price spoil)
  menuLoop conn

handleChoice conn "2" = do
  putStrLn "Enter ID to delete:"
  itemId <- readLn
  deleteItemDB conn itemId
  menuLoop conn

handleChoice conn "3" = do
  items <- getAllItems conn
  putStrLn "Current Inventory:"
  mapM_ print items
  menuLoop conn

handleChoice conn "4" = do
  items <- getAllItems conn
  putStrLn $ "Total Quantity: " ++ show (totalInventory items)
  putStrLn $ "Total Spoilage: " ++ show (totalSpoilage items)
  putStrLn "Restock Needed:"
  mapM_ (putStrLn . itemName) (restockNeeded items)
  -- Optional total value
  -- putStrLn $ "Total Inventory Value: " ++ show (totalInventoryValue items)
  menuLoop conn

handleChoice conn "5" = putStrLn "Exiting..."
handleChoice conn _   = menuLoop conn