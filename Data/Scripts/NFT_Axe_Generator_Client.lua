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

local function InList(seed)
	for i, item in ipairs(list) do
		if item.seed == seed then
			return true
		end
	end

	return false
end

local function ColorMeshes(item)
	local meshes = item:FindDescendantsByType("StaticMesh")
  
	for m, mesh in ipairs(meshes) do
		if mesh:GetCustomProperty("Ignore") == nil or not mesh:GetCustomProperty("Ignore") then
			local material_slots = mesh:GetMaterialSlots()

			for s, slot in ipairs(material_slots) do
				slot:SetColor(Color.New(RNG:GetNumber(), RNG:GetNumber(), RNG:GetNumber()))
			end
		end
	end
end

local function Generate()
	ClearPrevious()

	RNG:Mutate()

	currentItem = {

		seed = RNG.seed

	}

	local handleRow = HANDLES[RNG:GetInteger(1, #HANDLES)]

	currentItem.handle = World.SpawnAsset(handleRow.Template, { parent = CONTAINER })
	ColorMeshes(currentItem.handle)

	local bladeRow = BLADES[RNG:GetInteger(1, #BLADES)]
	currentItem.blade = World.SpawnAsset(bladeRow.Template, { parent = CONTAINER })

	ColorMeshes(currentItem.blade)

	if InList(currentItem.seed) then
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
		print("Handle:", item.handleIndex)
		print("Seed:", item.seed)

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