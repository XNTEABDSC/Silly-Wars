---@diagnostic disable: need-check-nil
function widget:GetInfo()
	return {
		name      = "Cheat Sheet",
		desc      = "Handy hax menu.",
		author    = "GoogleFrog, Sprung, then XNTEABDSC",
		date      = "2017-10-10",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		handler   = true,
		enabled   = true,
	}
end

VFS.Include("LuaRules/Configs/customcmds.h.lua")

local setAiPosCommand = {
---@diagnostic disable-next-line: undefined-global
	id      = CMD_CHEAT_GIVE,
	type    = CMDTYPE.ICON_MAP,
	tooltip = 'Spawn units.',
	cursor  = 'Attack',
	action  = 'cheatgive',
	params  = {},
	texture = 'LuaUI/Images/commands/Bold/attack.png',
	pos = {125},
}

-- configurables
local COMBOX_HEIGHT = 20
local BUTTON_SIZE = 32
local BUTTON_SPACING = 5

-- not really configurables
local CHECKBOX_SIZE = 16

-- variables
local spawnParams = {
	unit = nil,
	count = 1,
	team = 0,
}

local initialized = false

-- chili handles (mostly for text localisation)

local chbox = {}
local label = {}
local button = {}

local categoryPickerCombox
local unitPickers
local countSlider
local teamPicker
local controlTeamPicker
local controlItemToTeam = {}
local currentControlTeamItem = 1
local myPlayerID

-- misc derivative stuff
local categories = {}
local unitAlreadyProcessed = {}

local function AddCategory(transKey, unitList)
	for i = 1, #unitList do
		unitAlreadyProcessed[unitList[i]] = true
	end

	categories[#categories + 1] = {
		translation_key = transKey,
		unitList = unitList,
	}
end

local function AddMiscCategory(transKey, unitList)
	AddCategory("cheatsheet_cat_" .. transKey, unitList)
end

local function AddFacCategory(name)
	local ud = UnitDefNames[name]
	local unitList = {name}
	local offset = 1

	local plateName = ud.customParams.parent_of_plate
	if plateName then
		offset = 2
		unitList[offset] = plateName
	end

	local bo = ud.buildOptions
	for i = 1, #bo do
		unitList[i + offset] = UnitDefs[bo[i]].name
	end

	AddCategory("roster_" .. name, unitList)
end

local buildOpts = VFS.Include("gamedata/buildoptions.lua")
local factory_commands, econ_commands, defense_commands, special_commands = include("Configs/integral_menu_commands_processed.lua", nil, VFS.RAW_FIRST)
local econ_list, defense_list, special_list = {}, {}, {}
for i = 1, #buildOpts do
	local name = buildOpts[i]
	if econ_commands[-UnitDefNames[name].id] then
		econ_list[#econ_list + 1] = name
	elseif defense_commands[-UnitDefNames[name].id] then
		defense_list[#defense_list + 1] = name
	elseif special_commands[-UnitDefNames[name].id] then
		special_list[#special_list + 1] = name
	-- else fac; has its own category (though things can be in multiple cats if wanted)
	end
end


for i = 1, #econ_list do -- adv geo not directly buildable
	if econ_list[i] == "energygeo" then
		table.insert(econ_list, i + 1, "energyheavygeo")
		break
	end
end

AddFacCategory("factorycloak") -- not using the factory name to prevent category vs unit confusion
AddFacCategory("factoryshield")
AddFacCategory("factoryveh")
AddFacCategory("factorytank")
AddFacCategory("factoryhover")
AddFacCategory("factoryspider")
AddFacCategory("factoryamph")
AddFacCategory("factorygunship")
AddFacCategory("factoryplane")
AddFacCategory("factoryjump")
AddFacCategory("factoryship")
AddFacCategory("striderhub")
AddFacCategory("staticmissilesilo")
AddMiscCategory("eco", econ_list)
AddMiscCategory("defense", defense_list)
AddMiscCategory("intel_super", special_list)
AddMiscCategory("comms", {
	"dynhub_assault_base",
	"dynhub_recon_base",
	"dynhub_strike_base",
	"dynhub_support_base",
})
AddMiscCategory("chicken", { -- could probably autogenerate through 'chicken*' but here I put only those that are actually spawned
	"chicken",
	"chicken_blimpy",
	"chicken_dodo",
	"chicken_dragon",
	"chicken_pigeon",
	"chicken_roc",
	"chicken_shield",
	"chicken_spidermonkey",
	"chicken_sporeshooter",
	"chicken_tiamat",
	"chickena",
	"chickenblobber",
	"chickenc",
	"chickend",
	"chickenf",
	"chickenflyerqueen",
	"chickenr",
	"chickens",
	"chickenspire",
	"chickenwurm",
	"roost",
})
AddMiscCategory("subunits", {
	"dronecarry",
	"dronefighter",
	"droneheavyslow",
	"dronelight",
	"tele_beacon",
	"wolverine_mine",
})
AddMiscCategory("campaign", {
	"bomberassault",
	"bomberstrike",
	"dynknight0",
	"grebe",
	"hoverminer",
	"hovershotgun",
	"hoverskirm2",
	"hoversonic",
	"nebula",
	"turretsunlance",
	"spideranarchid",
	"staticsonar",
	"subscout",
})
AddMiscCategory("wacky", {
	"assaultcruiser",
	"chickenbroodqueen",
	"chicken_drone",
	"chicken_leaper",
	"chicken_rafflesia",
	"comm_campaign_isonade",
	"neebcomm",
	"rocksink",
	"starlight_satellite",
})


do
	local planetwars = {}
	local debugs={}
	for name, ud in pairs (UnitDefNames) do
		if ud.customParams.planetwars then
			planetwars[#planetwars + 1] = name
		elseif ud.customParams.is_debug_unit then
			debugs[#debugs+1] = name
		else
		end
	end
	AddMiscCategory("planetwars", planetwars)
	AddMiscCategory("debug",debugs)
end

do
	local rejects = {}
	for name, ud in pairs (UnitDefNames) do
		if not unitAlreadyProcessed[name] then
			rejects[#rejects + 1] = name
		end
	end
	AddMiscCategory("rejects", rejects)
end

-- helpers

local function SayAsHost(text)
	if Spring.GetModOptions().cheatcommandprefix then -- multiplayer
		Spring.SendCommands(Spring.GetModOptions().cheatcommandprefix .. text)
	else
		Spring.SendCommands(text)
	end
end

local function ToggleIfCheatsEnabled(self)
	if not chbox.cheat.state.checked then
		return
	end

	WG.Chili.Checkbox.Toggle(self)
end

local function GetNoCost() -- hax because there is no relevant Spring callout
	return UnitDefNames.energysingu.buildTime == 10 -- not 100% reliable but works with /reload
end

local function IsCheatingGameSetup()
	if VFS.FileExists("mission.lua") or Spring.GetModOptions().singleplayercampaignbattleid then
		return false
	end
	local teams = Spring.GetTeamList()
	local players = 0
	for i = 1, #teams do
		local teamID = teams[i]
		if teamID ~= Spring.GetGaiaTeamID() then
			local _, _, _, isAiTeam = Spring.GetTeamInfo(teamID)
			if not isAiTeam then
				players = players + 1
				if players > 1 then
					return false
				end
			else
				local _, aiName, _, aiLibrary = Spring.GetAIInfo(teamID)
				if not (string.find(aiLibrary, 'Null AI') or string.find(aiName, 'Inactive AI')) then
					return false
				end
			end
		end
	end
	return true
end

-- UI stuff creation

local function AddAtmButton(parent, x_offset, y_offset)
	button.atm = WG.Chili.Button:New{
		y = y_offset[1],
		x = x_offset[1],
		width = BUTTON_SIZE,
		height = BUTTON_SIZE,

		padding = {3,3,3,3},
		noFont = true,

		OnClick = { function(self)
			Spring.SendCommands("atm")
		end },
		parent = parent,
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		parent = button.atm,
		file = 'LuaUI/Images/metalplus.png',
	}

	x_offset[1] = x_offset[1] + BUTTON_SPACING + BUTTON_SIZE
end

local function AddClearButton(parent, x_offset, y_offset)
	button.clear = WG.Chili.Button:New{
		y = y_offset[1],
		x = x_offset[1],
		width = BUTTON_SIZE,
		height = BUTTON_SIZE,

		padding = {3,3,3,3},
		noFont = true,

		OnClick = { function(self)
			Spring.SendCommands("luarules clear")
		end },
		parent = parent,
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		parent = button.clear,
		file = 'LuaUI/Images/drawingcursors/eraser.png',
	}

	x_offset[1] = x_offset[1] + BUTTON_SPACING + BUTTON_SIZE
end

local function AddGentleKillButton(parent, x_offset, y_offset)
	button.gk = WG.Chili.Button:New{
		y = y_offset[1],
		x = x_offset[1],
		width = BUTTON_SIZE,
		height = BUTTON_SIZE,

		padding = {3,3,3,3},
		noFont = true,

		OnClick = { function(self)
			Spring.SendCommands("luarules gk")
		end },
		parent = parent,
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		parent = button.gk,
		file = 'LuaUI/Images/AttritionCounter/Skull.png',
	}

	x_offset[1] = x_offset[1] + BUTTON_SPACING + BUTTON_SIZE
end

local function AddRezButton(parent, x_offset, y_offset)
	button.rez = WG.Chili.Button:New{
		y = y_offset[1],
		x = x_offset[1],
		width = BUTTON_SIZE,
		height = BUTTON_SIZE,

		padding = {3,3,3,3},
		noFont = true,

		OnClick = { function(self)
			Spring.SendCommands("luarules rez")
		end },
		parent = parent,
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		parent = button.rez,
		file = 'LuaUI/Images/commands/Bold/resurrect.png',
	}

	x_offset[1] = x_offset[1] + BUTTON_SPACING + BUTTON_SIZE
end

local function AddGodmodeToggle(parent, offset)
	chbox.godmode = WG.Chili.Checkbox:New{
		x = CHECKBOX_SIZE + 2,
		y = offset[1],
		right = 0,
		checked = Spring.IsGodModeEnabled(),
		parent = parent,
		objectOverrideFont = WG.GetFont(),
		OnChange = {function(self, value)
			-- the param is a bitfield, 1 for allies and 2 for enemies, so
			-- in theory those could be separate toggles, but I don't think
			-- anybody minds the wider control
			SayAsHost("godmode " .. (value and 3 or 0))
		end},
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = offset[1],
		width = CHECKBOX_SIZE,
		height = CHECKBOX_SIZE,
		parent = parent,
		file = 'LuaUI/Images/commands/reclaim.png', -- hand (not the recycle triangle)
	}
	chbox.godmode.Toggle = ToggleIfCheatsEnabled
	offset[1] = offset[1] + CHECKBOX_SIZE
end

local function AddAllowFpsToggle(parent, offset)
	chbox.allowfps = WG.Chili.Checkbox:New{
		x = CHECKBOX_SIZE + 2,
		y = offset[1],
		right = 0,
		checked = not (Spring.GetGameRulesParam("fps_need_cheat") == 1),
		parent = parent,
		objectOverrideFont = WG.GetFont(),
		OnChange = {function(self, value)
			Spring.SendCommands("luarules allowfps " .. (value and 1 or 0))
		end},
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = offset[1],
		width = CHECKBOX_SIZE,
		height = CHECKBOX_SIZE,
		parent = parent,
		file = 'LuaUI/Images/commands/bold/attack.png', -- hand (not the recycle triangle)
	}
	chbox.allowfps.Toggle = ToggleIfCheatsEnabled
	offset[1] = offset[1] + CHECKBOX_SIZE
end

local function AddNocostToggle(parent, offset)
	chbox.nocost = WG.Chili.Checkbox:New{
		x = CHECKBOX_SIZE + 2,
		y = offset[1],
		right = 0,
		checked = GetNoCost(),
		parent = parent,
		objectOverrideFont = WG.GetFont(),
		OnChange = {function(self, value)
			SayAsHost("nocost "          .. (value and 1 or 0))
			Spring.SendCommands("luarules nocost " .. (value and 1 or 0))
		end},
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = offset[1],
		width = CHECKBOX_SIZE,
		height = CHECKBOX_SIZE,
		parent = parent,
		file = 'LuaUI/Images/commands/Bold/build.png',
	}
	chbox.nocost.Toggle = ToggleIfCheatsEnabled
	offset[1] = offset[1] + CHECKBOX_SIZE
end

local function AddGloballosToggle(parent, offset)
	chbox.globallos = WG.Chili.Checkbox:New{
		x = CHECKBOX_SIZE + 2,
		y = offset[1],
		right = 0,
		checked = false, -- FIXME Spring.GetGlobalLos(Spring.GetLocalAllyTeamID())
		parent = parent,
		objectOverrideFont = WG.GetFont(),
		OnChange = {function(self, value)
			SayAsHost("globallos " .. Spring.GetLocalAllyTeamID())
		end},
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = offset[1],
		width = CHECKBOX_SIZE,
		height = CHECKBOX_SIZE,
		parent = parent,
		file = 'LuaUI/Images/dynamic_comm_menu/eye.png',
	}
	chbox.globallos.Toggle = ToggleIfCheatsEnabled
	offset[1] = offset[1] + CHECKBOX_SIZE
end

local function AddCheatingToggle(parent, offset)
	chbox.cheat = WG.Chili.Checkbox:New{
		x = 0,
		y = offset[1],
		right = 0,
		checked = Spring.IsCheatingEnabled(),
		parent = parent,
		objectOverrideFont = WG.GetFont(),
		OnChange = {function(self, value)
			SayAsHost("cheat " .. (value and 1 or 0))
		end},
	}
	offset[1] = offset[1] + CHECKBOX_SIZE
end

local function AddButtons(parent, y_offset)
	y_offset[1] = y_offset[1] + 10
	local x_offset = {0}
	AddAtmButton       (parent, x_offset, y_offset)
	AddClearButton     (parent, x_offset, y_offset)
	AddGentleKillButton(parent, x_offset, y_offset)
	AddRezButton       (parent, x_offset, y_offset)
	y_offset[1] = y_offset[1] + BUTTON_SIZE + BUTTON_SPACING - 15
end

local function AddMiscControls(parent, offset)
	AddCheatingToggle(parent, offset)
	offset[1] = offset[1] + CHECKBOX_SIZE

	AddNocostToggle   (parent, offset)
	AddGloballosToggle(parent, offset)
	AddGodmodeToggle  (parent, offset)
	AddAllowFpsToggle (parent, offset)
	AddButtons        (parent, offset)
end

local function UpdateTeamControllerSelected()
	local newSelect
	if Spring.GetSpectatingState() then
		newSelect = 1
	else
		local myTeamID = Spring.GetMyTeamID()
		for i, item in ipairs(controlTeamPicker.items) do
			if myTeamID == controlItemToTeam[i] then
				newSelect = i
			end
		end
	end
	if newSelect then
		currentControlTeamItem = newSelect
		controlTeamPicker:Select(newSelect)
	end
end

local function MakeTeamControllerComboBoxes(parent, offset)
	controlTeamPicker = WG.Chili.ComboBox:New{
		x = 5,
		y = offset[1],
		right = 5,
		height = COMBOX_HEIGHT,
		topHeight = 10,
		items = {'Spectator'},

		parent = parent,
		objectOverrideFont = WG.GetFont(),
		OnSelect = {function(self, i)
			if Spring.IsCheatingEnabled() then
				if currentControlTeamItem == i then
					return
				end
				if i == 1 then
					Spring.SendCommands('spectator')
				elseif controlItemToTeam[i] then
					Spring.SendCommands('team ' .. controlItemToTeam[i])
				end
			end
		end},
	}
end

local function MakeTeamControllerLabel(parent, offset)
	label.ctrlteam = WG.Chili.Label:New{
		x = 0,
		right = 0,
		y = offset[1],
		height = 25,

		objectOverrideFont = WG.GetFont(16),
		align = "center",
		autosize = false,
		parent = parent,
	}
	offset[1] = offset[1] + 25
end

local function AddTeamController(parent, offset)
	offset[1] = offset[1] + 15
	MakeTeamControllerLabel     (parent, offset)
	MakeTeamControllerComboBoxes(parent, offset)
	offset[1] = offset[1] + 10
end


local function MakeUnitPickerComboxes(parent, offset)
	unitPickers = {}
	for i = 1, #categories do
		unitPickers[i] = WG.Chili.ComboBox:New{
			x = 5,
			y = offset[1] + COMBOX_HEIGHT + 2,
			right = 5,
			height = COMBOX_HEIGHT,
			items = {},
			parent = parent,
			objectOverrideFont = WG.GetFont(),
			OnSelect = {function(self, j)
				spawnParams.unit = categories[i].unitList[j]
			end},
		}
		unitPickers[i]:Hide()
	end

	categoryPickerCombox = WG.Chili.ComboBox:New{
		x = 5,
		y = offset[1],
		right = 5,
		height = COMBOX_HEIGHT,
		topHeight = 10,
		items = {},
		parent = parent,
		selected = 1,
		objectOverrideFont = WG.GetFont(),
		OnSelect = {function(self, i)
			if i == 1 then
				spawnParams.unit = nil
			end
			for j = 1, #unitPickers do
				if i == (j+1) then
					unitPickers[j]:Select(unitPickers[j].selected)
					unitPickers[j]:Show()
				else
					unitPickers[j]:Hide()
				end
			end
		end},
	}

	offset[1] = offset[1] + 2 * (COMBOX_HEIGHT + 2)
end

local function MakeTeamPickerCombox(parent, offset)
	local teams = Spring.GetTeamList()
	teamPicker = WG.Chili.ComboBox:New{
		x = 5,
		y = offset[1],
		right = 5,
		height = COMBOX_HEIGHT,
		topHeight = 10,
		items = {},
		parent = parent,
		objectOverrideFont = WG.GetFont(),
		OnSelect = {function(self, i)
			spawnParams.team = teams[i]
		end},
	}
	offset[1] = offset[1] + COMBOX_HEIGHT + 2
end

local function MakeCountPicker(parent, offset)
	countSlider = WG.Chili.Trackbar:New{
		x = 5,
		y = offset[1],
		right = 5,
		height = COMBOX_HEIGHT,

		value = 1,
		min = 1,
		max = 25,
		step = 1,
		OnChange = { function(self, i)
			spawnParams.count = i
		end },

		parent = parent,
	}
	offset[1] = offset[1] + COMBOX_HEIGHT
end

local function MakeSpawnButton(parent, offset)
	button.spawn = WG.Chili.Button:New{
		y = offset[1] + 5,
		right = 0,
		width = BUTTON_SIZE,
		height = BUTTON_SIZE,

		padding = {3,3,3,3},
		noFont = true,

		OnClick = {
			function(self)
				Spring.SetActiveCommand("cheatgive", 1)
			end
		},
		parent = parent,
	}

	local pic = WG.Chili.Image:New{
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		parent = button.spawn,
		file = 'LuaUI/Images/gift2.png',
	}

	offset[1] = offset[1] + 30
end

local function MakeSpawnLabel(parent, offset)
	label.spawn = WG.Chili.Label:New{
		x = 0,
		right = 0,
		y = offset[1],
		height = 25,

		objectOverrideFont = WG.GetFont(16),
		align = "center",
		autosize = false,

		parent = parent,
	}
	offset[1] = offset[1] + 25
end

local function AddSpawnUnitStuff(parent, offset)
	offset[1] = offset[1] + 15
	MakeSpawnLabel        (parent, offset)
	MakeUnitPickerComboxes(parent, offset)
	MakeTeamPickerCombox  (parent, offset)
	MakeCountPicker       (parent, offset)
	MakeSpawnButton       (parent, offset)
end

local function InitializeControls()
	if initialized then
		return
	end
	initialized = true

	local mainWindow = WG.Chili.Window:New{
		classname = "main_window_small_tall",
		name      = 'CheatSheetWindow',
		x         =  50,
		y         = 150,
		width     = 250,
		height    = 400,
		minWidth  = 250,
		minHeight = 400,
		padding = {16, 8, 16, 8},
		dockable  = true,
		dockableSavePositionOnly = true,
		draggable = true,
		resizable = false,
		tweakResizable = true,
		parent = WG.Chili.Screen0,
	}

	label.top = WG.Chili.Label:New{
		x      = 0,
		right  = 0,
		y      = 0,
		height = 35,
		valign = "center",
		align  = "center",
		autosize = false,
		objectOverrideFont = WG.GetSpecialFont(20, "cheat",{
			size = 20, outline = true, color = {.8,.8,.8,.9}, outlineWidth = 2, outlineWeight = 2
		}),
		parent = mainWindow,
	}

	local offset = {40}
	AddMiscControls  (mainWindow, offset)
	AddTeamController(mainWindow, offset)
	AddSpawnUnitStuff(mainWindow, offset)
	if WG.GlobalCommandBar then
		local function ToggleWindow()
			if mainWindow.visible then
				mainWindow:Hide()
			else
				mainWindow:Show()
				mainWindow:BringToFront()
			end
		end
		if WG.cheat_global_button then -- work around since GlobalCommandBar doesn't have a remove function
			WG.cheat_global_button.OnClick = {ToggleWindow}
			WG.cheat_global_button:Show()
		else
			WG.cheat_global_button = WG.GlobalCommandBar.AddCommand("LuaRules/Images/awards/trophy_friend.png", "", ToggleWindow)
		end
	end
	languageChanged() -- update texts

	mainWindow:Hide()




	return mainWindow
end

-- localisation

---@diagnostic disable-next-line: lowercase-global
function languageChanged()
	if not initialized then
		return
	end

	if WG.cheat_global_button then
		WG.cheat_global_button.tooltip = WG.Translate("interface", "toggle_cheatsheet_name") .. "\n\n" .. WG.Translate("interface", "toggle_cheatsheet_desc")
		WG.cheat_global_button:Invalidate()
	end

	categoryPickerCombox.items[1] = WG.Translate("interface", "cheatsheet_no_category")
	for i = 1, #categories do
		categoryPickerCombox.items[i + 1] = WG.Translate("interface", categories[i].translation_key) or categories[i].translation_key

		for j = 1, #categories[i].unitList do
			unitPickers[i].items[j] = Spring.Utilities.GetHumanName(UnitDefNames[categories[i].unitList[j]])
		end
		unitPickers[i].tooltip = WG.Translate("interface", "cheatsheet_pick_unit")
		unitPickers[i]:Select(unitPickers[i].selected)
	end
	categoryPickerCombox.tooltip = WG.Translate("interface", "cheatsheet_pick_category")
	categoryPickerCombox:Select(categoryPickerCombox.selected)
	for name, btn in pairs (button) do
		btn.tooltip = WG.Translate("interface", "cheatsheet_btn_" .. name)
		btn:Invalidate()
	end
	for name, chb in pairs (chbox) do
		chb.tooltip = WG.Translate("interface", "cheatsheet_chb_" .. name .. "_desc")
		chb.caption = WG.Translate("interface", "cheatsheet_chb_" .. name)
		chb:Invalidate()
	end
	for name, lab in pairs (label) do
		lab:SetCaption(WG.Translate("interface", "cheatsheet_lab_" .. name))
	end

	countSlider.tooltip_format = WG.Translate("interface", "cheatsheet_count_slider")
	countSlider:SetValue(countSlider.value)

	controlTeamPicker.items[1] = WG.Translate("interface", "cheatsheet_ctrlteam_spec")

	local teams = Spring.GetTeamList()
	for i = 1, #teams do
		local teamID = teams[i]
		local _,playerID,_,isAI = Spring.GetTeamInfo(teamID, false)

		if Spring.GetGaiaTeamID() == teamID then
			teamPicker.items[i] = WG.Translate("interface", "neutral")
			-- Spring refuse to give control of the neutral team, saying it doesn't exist
			-- controlTeamPicker.items[#controlTeamPicker.items + 1] = teamPicker.items[i]
			-- controlItemToTeam[#controlTeamPicker.items] = teamID
		elseif isAI then
			local _,botID,_,shortName = Spring.GetAIInfo(teamID)
			teamPicker.items[i] = (shortName or "Bot") .." - " .. (botID or "")
			controlTeamPicker.items[#controlTeamPicker.items + 1] = teamPicker.items[i]
			controlItemToTeam[#controlTeamPicker.items] = teamID
		else
			teamPicker.items[i] = Spring.GetPlayerInfo(playerID, false) or "???"
			controlTeamPicker.items[#controlTeamPicker.items + 1] = teamPicker.items[i]
			controlItemToTeam[#controlTeamPicker.items] = teamID
		end
	end
	teamPicker.tooltip = WG.Translate("interface", "cheatsheet_teampick_desc")
	teamPicker:Select(teamPicker.selected)
	teamPicker:Invalidate()

	controlTeamPicker.tooltip = WG.Translate("interface", "cheatsheet_ctrlteampick_desc")
	UpdateTeamControllerSelected()
end

-- WH interface

function widget:PlayerChanged(playerID)
	if playerID == myPlayerID then
		if controlTeamPicker then
			UpdateTeamControllerSelected()
		end
	end
end

function widget:CommandNotify(cmdID, cmdParams, cmdOptions)
---@diagnostic disable-next-line: undefined-global
	if cmdID ~= CMD_CHEAT_GIVE then
		return
	end

	if spawnParams.unit == nil then
		return true
	end

	Spring.SendCommands("give " .. spawnParams.count .. " " .. spawnParams.unit .. " " .. spawnParams.team)
	return true
end

function widget:AddConsoleLine(msg)
	if msg == "Cheating is enabled!" then
		InitializeControls()

		chbox.cheat.state.checked = true
		chbox.cheat:Invalidate()
		return
	end
	if msg == "Cheating is disabled!" then
		--[[ Don't disable the controls (in particular, keep
		     the button on the top bar). This is so that:
		     * you can easily reenable cheats
		     * check status (since /cheat just sets whether
		       you can toggle other cheats, not their effects)
		     * serves as a taint mark to detect haxed games. ]]
		chbox.cheat.state.checked = false
		chbox.cheat:Invalidate()
		return
	end

	if msg == "God-Mode is enabled!" then
		chbox.godmode.state.checked = true
		chbox.godmode:Invalidate()
		return
	end
	if msg == "God-Mode is disabled!" then
		chbox.godmode.state.checked = false
		chbox.godmode:Invalidate()
		return
	end

	if msg == "First person view enabled, select a unit and press Alt+P." then
		chbox.allowfps.state.checked = true
		chbox.allowfps:Invalidate()
		return
	end
	if msg == "First person view disabled." then
		chbox.allowfps.state.checked = false
		chbox.allowfps:Invalidate()
		return
	end

	if msg == "Everything-for-free (no resource costs for building) is enabled!" then
		chbox.nocost.state.checked = true
		chbox.nocost:Invalidate()
		return
	end
	if msg == "Everything-for-free (no resource costs for building) is disabled!" then
		chbox.nocost.state.checked = false
		chbox.nocost:Invalidate()
		return
	end

	-- Toggling based on messages is worse than doing nothing, because clicking the tickbox already toggles.
	-- At least togging on the UI will make the state correct for the host.
	--local a, b = msg:find("global LOS toggled for allyteam ")
	--if b then
	--	local teamID = tonumber(msg:sub(b+1))
	--	if teamID == Spring.GetLocalAllyTeamID() then
	--		chbox.globallos.state.checked = not chbox.globallos.state.checked
	--		chbox.globallos:Invalidate()
	--	end
	--	return
	--end
	--
	--if msg:find("global LOS toggled for all allyteams") then
	--	chbox.globallos.state.checked = not chbox.globallos.state.checked
	--	chbox.globallos:Invalidate()
	--	return
	--end
end

function widget:CommandsChanged()
	local customCommands = widgetHandler.customCommands
	table.insert(customCommands, setAiPosCommand)
end

function widget:Initialize()
---@diagnostic disable-next-line: undefined-global
	WG.InitializeTranslation (languageChanged, GetInfo().name)
	myPlayerID = Spring.GetMyPlayerID()

	--[[ Don't display the controls (esp. the top bar button) before
	     cheats are actually enabled for the first time. This way:
	     * clutter is avoided (most MP games won't have cheats)
	     * the button's presence is a soft "game is tainted" cheat mark
	     * having to manually type a /command first gives the ~HACKERMAN~ vibes ]]
	if Spring.IsCheatingEnabled() or IsCheatingGameSetup() then
		InitializeControls()
	end
end
