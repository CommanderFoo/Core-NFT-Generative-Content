local JSON = require(script:GetCustomProperty("JSON"))

local PARENT_OBJECT = script:GetCustomProperty("ParentObject"):WaitForObject()
local BLADES = require(script:GetCustomProperty("Blades"))
local HANDLES = require(script:GetCustomProperty("Handles"))
local MATERIALS = require(script:GetCustomProperty("Materials"))

local currentItem = {}

local list = {}

UI.SetCursorVisible(true)

local function ClearPrevious()
	if Object.IsValid(currentItem.blade) then
		currentItem.blade:Destroy()
	end

	if Object.IsValid(currentItem.handle) then
		currentItem.handle:Destroy()
	end

	currentItem = {}
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

local function ColorMeshes(parent, color, key, slotName)
	local meshes = parent:FindDescendantsByType("StaticMesh")

	for m, mesh in ipairs(meshes) do
		if mesh:GetCustomProperty("Ignore") == nil or not mesh:GetCustomProperty("Ignore") then
			local material_slots = mesh:GetMaterialSlots()

			for s, slot in ipairs(material_slots) do
				if string.find(tostring(slot), slotName) then
					slot:SetColor(color)
					currentItem[key] = color
				end
			end
		end
	end
end

local function ToStandardHex(color)
	if(color) then
		return color:ToStandardHex()
	end

	return ""
end

local function Generate()
	ClearPrevious()

	local bladeParent = PARENT_OBJECT:FindChildByName("Blade")
	local handleParent = PARENT_OBJECT:FindChildByName("Handle")

	currentItem.bladePrimaryColor = Color.New(math.random(), math.random(), math.random())
	currentItem.bladeSecondaryColor = Color.New(math.random(), math.random(), math.random())
	currentItem.bladeTertiaryColor = Color.New(math.random(), math.random(), math.random())

	local bladeIndex = math.random(#BLADES)
	local bladeRow = BLADES[bladeIndex]

	bladeParent:SetPosition(bladeRow.Offset)
	currentItem.blade = World.SpawnAsset(bladeRow.Template, { parent = bladeParent })
	currentItem.bladeIndex = bladeIndex

	if bladeRow.PrimaryColor then
		ColorMeshes(bladeParent, Color.New(math.random(), math.random(), math.random()), "bladePrimaryColor", "BaseMaterial")
	end

	if bladeRow.SecondaryColor then
		ColorMeshes(bladeParent, Color.New(math.random(), math.random(), math.random()), "bladeSecondaryColor", "Detail1")
	end

	if bladeRow.TertiaryColor then
		ColorMeshes(bladeParent, Color.New(math.random(), math.random(), math.random()), "bladeTertiaryColor", "Detail2")
	end

	currentItem.handlePrimaryColor = Color.New(math.random(), math.random(), math.random())
	currentItem.handleSecondaryColor = Color.New(math.random(), math.random(), math.random())
	currentItem.handleTertiaryColor = Color.New(math.random(), math.random(), math.random())

	local handleIndex = math.random(#HANDLES)
	local handleRow = HANDLES[handleIndex]

	handleParent:SetPosition(handleRow.Offset)
	currentItem.handle = World.SpawnAsset(handleRow.Template, { parent = handleParent })
	currentItem.handleIndex = handleIndex

	if handleRow.PrimaryColor then
		ColorMeshes(handleParent, Color.New(math.random(), math.random(), math.random()), "handlePrimaryColor", "BaseMaterial")
	end

	if handleRow.SecondaryColor then
		ColorMeshes(handleParent, Color.New(math.random(), math.random(), math.random()), "handleSecondaryColor", "Detail1")
	end

	if handleRow.TertiaryColor then
		ColorMeshes(handleParent, Color.New(math.random(), math.random(), math.random()), "handleTertiaryColor", "Detail2")
	end

	if InList(currentItem) then
		print("Item exists already")
	else
		print(string.format("Blade: %s\nBlade Primary: %s\nBlade Secondary: %s\nBlade Tertiary: %s\nOffset: %s",

			currentItem.bladeIndex,
			ToStandardHex(currentItem.bladePrimaryColor),
			ToStandardHex(currentItem.bladeSecondaryColor),
			ToStandardHex(currentItem.bladeTertiaryColor),
			bladeRow.Offset

		))

		print(string.format("Handle: %s\nHandle Primary: %s\nHandle Secondary: %s\nHandle Tertiary: %s\nOffset: %s",

			currentItem.handleIndex,
			ToStandardHex(currentItem.handlePrimaryColor),
			ToStandardHex(currentItem.handleSecondaryColor),
			ToStandardHex(currentItem.handleTertiaryColor),
			handleRow.Offset

		))

		list[#list + 1] = currentItem
	end
end

local function output()
	print("Start Output")

	local output = {}

	for index, item in ipairs(list) do
		local entry = {

			blade = item.bladeIndex,
			handle = item.handleIndex

		}

		output[#output + 1] = entry

		print(string.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",

			item.bladeIndex,
			item.handleIndex,
			ToStandardHex(item.bladePrimaryColor),
			ToStandardHex(item.bladeSecondaryColor),
			ToStandardHex(item.bladeTertiaryColor),
			ToStandardHex(item.handlePrimaryColor),
			ToStandardHex(item.handleSecondaryColor),
			ToStandardHex(item.handleTertiaryColor)

		))
	end

	print("End Output")
end

Input.actionPressedEvent:Connect(function(player, action)
	if action == "Shoot" then
		Generate()
	elseif action == "Aim" then
		output()
	elseif action == "Discard Last Axe" then
		ClearPrevious()
		list[#list] = nil
	end
end)