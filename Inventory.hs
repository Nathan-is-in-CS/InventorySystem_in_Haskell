module Inventory where

import Types

-- | Total quantity of all items
totalInventory :: [Item] -> Int
totalInventory = sum . map quantity

-- | Total spoilage of all items
totalSpoilage :: [Item] -> Int
totalSpoilage = sum . map spoilage

-- | Items that need restocking (quantity < threshold)
restockNeeded :: [Item] -> [Item]
restockNeeded = filter ((< 10) . quantity)  -- threshold can be parameterized if needed

-- | Value of a single item (quantity * price)
itemValue :: Item -> Double
itemValue item = fromIntegral (quantity item) * price item

-- | Total value of all items
totalInventoryValue :: [Item] -> Double
totalInventoryValue = sum . map itemValue

-- | Average price of all items (ignoring quantity)
averagePrice :: [Item] -> Double
averagePrice [] = 0
averagePrice items = sum (map price items) / fromIntegral (length items)

-- | Average value per item type (quantity * price / # of items)
averageItemValue :: [Item] -> Double
averageItemValue [] = 0
averageItemValue items = totalInventoryValue items / fromIntegral (length items)