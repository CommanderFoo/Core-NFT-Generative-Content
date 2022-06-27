---@type NFT_Axe_Loader
local NFT_Axe_Loader = require(script:GetCustomProperty("NFT_Axe_Loader"))

local CLIENT_GEO = script:GetCustomProperty("ClientGeo"):WaitForObject()
local LOADING_GEO = script:GetCustomProperty("LoadingGeo"):WaitForObject()

script:FindAncestorByType("Equipment").equippedEvent:Connect(function(equipment, player)
	NFT_Axe_Loader.load(player, CLIENT_GEO, LOADING_GEO)
end)