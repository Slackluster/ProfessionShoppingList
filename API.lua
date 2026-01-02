---------------------------------------
-- Profession Shopping List: API.lua --
---------------------------------------

-- Toggle the window
ProfessionShoppingList:ToggleWindow()

-- Switch between Ragnaros and Pierre for the button PSL adds
ProfessionShoppingList:SwapCookingPet()

-- Check if an item's appearance is collected; returns true or false
ProfessionShoppingList:IsAppearanceCollected(itemLink)

-- Check if an item's source is collected; returns true or false
ProfessionShoppingList:IsSourceCollected(itemLink)
