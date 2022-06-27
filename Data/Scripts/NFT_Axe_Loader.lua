local ASYNC_BLOCKCHAIN = require(script:GetCustomProperty("AsyncBlockchain"))

local BLADES = require(script:GetCustomProperty("Blades"))
local HANDLES = require(script:GetCustomProperty("Handles"))
local GRIPS = require(script:GetCustomProperty("Grips"))
local GUARDS = require(script:GetCustomProperty("Guards"))
local MATERIALS = require(script:GetCustomProperty("Materials"))
local COLORS = require(script:GetCustomProperty("Colors"))

local NFT_Axe_Loader = {}

function NFT_Axe_Loader.load(player, client_geo_folder, loading_geo_folder)
	ASYNC_BLOCKCHAIN.GetTokensForPlayer(player, { contractAddress = "0x495f947276749ce646f68ac8c248420045cb7b5e" }, function(tokens)
		if(Object.IsValid(player) and #tokens > 0) then
			local token = tokens[math.random(#tokens)]

			print(token.name)
		end
	end)
end

return NFT_Axe_Loader