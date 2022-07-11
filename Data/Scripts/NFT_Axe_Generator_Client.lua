local BLADES = require(script:GetCustomProperty("Blades"))
local HANDLES = require(script:GetCustomProperty("Handles"))
local CONTAINER = script:GetCustomProperty("Container"):WaitForObject()

local currentItem = nil
local list = {}
local RNG = RandomStream.New(1)

UI.SetCursorVisible(true)

local function ClearPrevious()
	if currentItem ~= nil then
		if Object.IsValid(currentItem.blade) then
			currentItem.blade:Destroy()
		end

		if Object.IsValid(currentItem.handle) then
			currentItem.handle:Destroy()
		end
	end

	currentItem = nil
end

local function InList(newItem)
	for i, item in ipairs(list) do
		if newItem.bladeIndex == item.bladeIndex and newItem.handleIndex == item.handleIndex then
			local bladeCondition = (

				newItem.bladePrimaryColor == item.bladePrimaryColor

				and

				newItem.bladeSecondaryColor == item.bladeSecondaryColor

				and

				newItem.bladeTertiaryColor == item.bladeTertiaryColor

			)

			local handleCondition = (

				newItem.handlePrimaryColor == item.handlePrimaryColor

				and

				newItem.handleSecondaryColor == item.handleSecondaryColor

				and

				newItem.handleTertiaryColor == item.handleTertiaryColor

			)

			if bladeCondition and handleCondition then
				return true
			end
		end
	end

	return false
end

local function ColorMeshes(color, key, slotName)
	local meshes = CONTAINER:FindDescendantsByType("StaticMesh")

	for m, mesh in ipairs(meshes) do
		if mesh:GetCustomProperty("Ignore") == nil or not mesh:GetCustomProperty("Ignore") then
			local material_slots = mesh:GetMaterialSlots()

			for s, slot in ipairs(material_slots) do
				if(key == "handlePrimaryColor") then
					print(slot.slotName)
				end

				if string.find(tostring(slot), slotName) then
					slot:SetColor(color)
					currentItem[key] = color
				end
			end
		end
	end
end

local function ToStandardHex(color)
	if color then
		return color:ToStandardHex():sub(2)
	end

	return "--"
end

local function Generate()
	ClearPrevious()

	currentItem = {
		
		handlePrimaryColor = Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()),
		handleSecondaryColor = Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()),
		handleTertiaryColor = Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber())

	}

	local handleIndex = math.random(#HANDLES)
	local handleRow = HANDLES[handleIndex]

	currentItem.handle = World.SpawnAsset(handleRow.Template, { parent = CONTAINER })

	ColorMeshes(Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()), "handlePrimaryColor", "BaseMaterial")
	ColorMeshes(Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()), "handleSecondaryColor", "Detail1")
	ColorMeshes(Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()), "handleTertiaryColor", "Detail2")

	currentItem.bladePrimaryColor = Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber())
	currentItem.bladeSecondaryColor = Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber())
	currentItem.bladeTertiaryColor = Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber())

	local bladeIndex = math.random(#BLADES)
	local bladeRow = BLADES[bladeIndex]

	currentItem.blade = World.SpawnAsset(bladeRow.Template, { parent = CONTAINER })
	currentItem.bladeIndex = bladeIndex

	ColorMeshes(Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()), "bladePrimaryColor", "BaseMaterial")
	ColorMeshes(Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()), "bladeSecondaryColor", "Detail1")
	ColorMeshes(Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()), "bladeTertiaryColor", "Detail2")
	
	if InList(currentItem) then
		print("Item exists already")
		ClearPrevious()
	end
end

local function AddToList()
	if currentItem ~= nil then
		list[#list + 1] = currentItem
	end
end

local function output()
	local output = {}

	for index, item in ipairs(list) do
		local entry = {

			blade = item.bladeIndex,
			handle = item.handleIndex

		}

		output[#output + 1] = entry

		print("Blade:", item.bladeIndex)

		print("Blade Primary Color:", ToStandardHex(item.bladePrimaryColor))
		print("Blade Secondary Color:", ToStandardHex(item.bladeSecondaryColor))
		print("Blade Tertiary Color:", ToStandardHex(item.bladeTertiaryColor))

		print("Handle Primary Color:", ToStandardHex(item.handlePrimaryColor))
		print("Handle Secondary Color:", ToStandardHex(item.HandleSecondaryColor))
		print("Handle Tertiary Color:", ToStandardHex(item.HandleTertiaryColor))
	
		print("------------------------------")
	end
end

Input.actionPressedEvent:Connect(function(player, action)
	if action == "Shoot" then
		Generate()
	elseif action == "Jump" then
		output()
	elseif action == "Aim" then
		AddToList()
	end
end)