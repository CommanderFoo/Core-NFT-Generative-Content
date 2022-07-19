local BLADES = require(script:GetCustomProperty("Blades"))
local HANDLES = require(script:GetCustomProperty("Handles"))
local TOKENS = require(script:GetCustomProperty("Tokens"))

local NFT_Axe_Loader = {}

function NFT_Axe_Loader.ColorMeshes(item, seed)
	local meshes = item:FindDescendantsByType("StaticMesh")
	local ColorRNG = RandomStream.New(seed)

	for m, mesh in ipairs(meshes) do
		if mesh:GetCustomProperty("Ignore") == nil or not mesh:GetCustomProperty("Ignore") then
			local material_slots = mesh:GetMaterialSlots()

			for s, slot in ipairs(material_slots) do
				slot:SetColor(Color.New(ColorRNG:GetNumber(), ColorRNG:GetNumber(), ColorRNG:GetNumber()))
			end
		end
	end
end

function NFT_Axe_Loader.load(player, parentGroup)
	local tokenID = TOKENS[math.random(#TOKENS)].TokenID
	local token, status, errorMsg = Blockchain.GetToken("0x495f947276749ce646f68ac8c248420045cb7b5e", tokenID)

	if status == BlockchainTokenResultCode.SUCCESS then
		local attributes = token:GetAttributes()
		
		for index, child in ipairs(parentGroup:GetChildren()) do
			child:Destroy()
		end
		
		for index, attribute in ipairs(attributes) do
			if(attribute.name == "Blade") then
				World.SpawnAsset(BLADES[tonumber(attribute:GetValue())].Template, { parent = parentGroup, networkContext = NetworkContextType.NETWORKED })
			end

			if(attribute.name == "Handle") then
				World.SpawnAsset(HANDLES[tonumber(attribute:GetValue())].Template, { parent = parentGroup, networkContext = NetworkContextType.NETWORKED })
			end

			if(attribute.name == "Seed") then
				NFT_Axe_Loader.ColorMeshes(parentGroup, attribute:GetValue())
			end
		end
	else
		print(errorMsg)
	end
end

return NFT_Axe_Loader