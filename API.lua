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

-- Track a recipe
-- recipeID: number
-- recipeQuantity: number
-- recraft: boolean, optional, defaults to false
-- orderID: number, optional, used to determine provided reagents
ProfessionShoppingList:TrackRecipe(recipeID, recipeQuantity, recraft, orderID)

-- Untrack a recipe
-- recipeID: number
-- recipeQuantity: number, use 0 to untrack all
ProfessionShoppingList:UntrackRecipe(recipeID, recipeQuantity)

-- Event that fires when tracked recipes are changed; returns recipeID and new quantity (nil for both if all recipes are cleared)
EventRegistry:RegisterCallback("ProfessionShoppingList.OnTrackedRecipesChanged",
	function(_, recipeID, newQuantity) ... end, owner)
