

VFS.Include("LuaRules/Utilities/ordered_list.lua")
local ordered_list=Spring.Utilities.OrderedList


local ordered_includes=ordered_list.New()


local includes = {
	--"headers/autolocalizer.lua",
	"headers/util.lua",
	"headers/links.lua",
	"headers/backwardcompability.lua",
	"headers/unicode.lua",

	"handlers/debughandler.lua",
	"handlers/taskhandler.lua",
	"handlers/skinhandler.lua",
	"handlers/themehandler.lua",
	"handlers/fonthandler.lua",
	"handlers/texturehandler.lua",

	"controls/object.lua",
	"controls/font.lua",
	"controls/control.lua",
	"controls/screen.lua",
	"controls/window.lua",
	"controls/label.lua",
	"controls/button.lua",
	"controls/editbox.lua",
	"controls/textbox.lua", -- uses editbox
	"controls/checkbox.lua",
	"controls/trackbar.lua",
	"controls/colorbars.lua",
	"controls/scrollpanel.lua",
	"controls/image.lua",
	"controls/layoutpanel.lua",
	"controls/grid.lua",
	"controls/stackpanel.lua",
	"controls/imagelistview.lua",
	"controls/progressbar.lua",
	"controls/multiprogressbar.lua",
	"controls/scale.lua",
	"controls/panel.lua",
	"controls/treeviewnode.lua",
	"controls/treeview.lua",
	"controls/line.lua",
	"controls/combobox.lua",
	"controls/tabbaritem.lua",
	"controls/tabbar.lua",
	"controls/tabpanel.lua",
	"controls/detachabletabpanel.lua",
}


for i = 1, #includes do
	ordered_includes.Add(
		{
			k=includes[i],
			v=includes[i],
			a={includes[i+1]}
		}
	)
end


---@diagnostic disable: undefined-global
local luaFiles=VFS.DirList(CHILI_DIRNAME or ((LUAUI_DIRNAME or LUA_DIRNAME) .. "Widgets/chili/") .. "includes_order", "*.lua") or {}
for i = 1, #luaFiles do
    local res=VFS.Include(luaFiles[i])
	for key, value in pairs(res) do
		ordered_includes.Add(value)
	end
end

local final_includes=ordered_includes.GenList()

local Chili = widget

Chili.CHILI_DIRNAME = CHILI_DIRNAME or ((LUAUI_DIRNAME or LUA_DIRNAME) .. "Widgets/chili/")
Chili.SKIN_DIRNAME  =  SKIN_DIRNAME or (CHILI_DIRNAME .. "skins/")
---@diagnostic enable: undefined-global

if (-1 > 0) then
	Chili = {}
	-- make the table strict
	VFS.Include(Chili.CHILI_DIRNAME .. "headers/strict.lua")(Chili, widget)
end

for _, file in ipairs(final_includes) do
	VFS.Include(Chili.CHILI_DIRNAME .. file, Chili, VFS.RAW_FIRST)
end


return Chili
