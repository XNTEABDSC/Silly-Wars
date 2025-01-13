   
-- $Id: ModOptions.lua 4642 2009-05-22 05:32:36Z carrepairer $


--  Custom Options Definition Table format
--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type ('list','string','number','bool')
--  def:      the default value
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  section:  so lobbies can order options in categories/panels
--  scope:    'all', 'player', 'team', 'allyteam'      <<< not supported yet >>>
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Example ModOptions.lua
--

local options = {
  -- do deployment and tactics even work?
  {
    key    = 'a_important',
    name   = 'Important',
    desc   = 'Commonly used options.',
    type   = 'section',
  },
  {
    key    = 'startconds',
    name   = 'Start',
    desc   = 'Start condition settings.',
    type   = 'section',
  },
  {
    key    = 'mapsettings',
    name   = 'Map',
    desc   = 'Map settings.',
    type   = 'section',
  },
  {
    key    = 'multipliers',
    name   = 'Multipliers',
    desc   = 'Statistics multipliers.',
    type   = 'section',
  },
  {
    key    = 'silly', -- lava, fun, zombies
    name   = 'Silly',
    desc   = 'Silly options for trolling.',
    type   = 'section',
  },
	{
		key     = 'mutespec',
		name    = 'Mute Spectators',
		desc    = 'Determines whether spectators can talk to players.',
		type    = 'list',
		section = 'a_important',
		def     = 'autodetect',
		items   = {
			{ key='mute', name = "Mute", desc = 'Mutes spectators.' },
			{ key='autodetect', name = "Autodetect", desc = 'Mutes spectators in FFA (more than two teams).' },
			{ key='nomute', name = "No Mute", desc = 'Does not mute spectators.' },
		},
	},
	{
		key     = 'mutelobby',
		name    = 'Mute Lobby',
		desc    = 'Determines whether chat in the lobby is visible ingame.',
		type    = 'list',
		section = 'a_important',
		def     = 'autodetect',
		items   = {
			{ key='mute', name = "Mute", desc = 'Mutes the lobby.' },
			{ key='autodetect', name = "Autodetect", desc = 'Mutes the lobby in FFA (more than two teams).' },
			{ key='nomute', name = "No Mute", desc = 'Does not mute the lobby.' },
		},
	},
	{
		key     = 'sharemode',
		name    = 'Commshare',
		desc    = 'Determines whether players can merge together during gameplay.',
		type    = 'list',
		section = 'a_important',
		def     = 'invite',
		items   = {
			{ key='all', name = "Merge All", desc = 'Merges all at game start. Recommend using allowunmerge = false with this.' },
			{ key='invite', name = "Invite Only", desc = 'Allows players to merge only if both give consent.' },
			{ key='none', name = "Off", desc = 'Turns commsharing off.' },
		},
	},
  {
    key    = 'mods',
    name   = 'mods',
    desc   = "Extra mods. See source code for mods :3, in both gamedata/mods/ and gamedata/lua_mods/ ",
    type   = 'string',
    section= 'silly',
    def    = "silly()",
  },
  {
    key    = 'zombies',
    name   = 'Enable zombies',
    desc   = "All features self-resurrect.",
    type   = 'bool',
    section= 'silly',
    def    = false,
  },
  {
    key    = 'zombies_delay',
    name   = 'Zombie min spawn time',
    desc   = "In seconds, unit will resurrection no faster than this.",
    type   = 'number',
    section= 'silly',
    def=10,
    min=1,
    max=600,
    step=1,
  },
  {
    key    = 'zombies_rezspeed',
    name   = 'Zombie resurrection speed',
    desc   = "In metal per second.",
    type   = 'number',
    section= 'silly',
    def=12,
    min=1,
    max=10000,
    step=1,
  },
  {
    key    = 'zombies_permaslow',
    name   = 'Zombie permaslow modifier',
    desc   = "If more than 0 zombies are permaslowed to half of that amount, so 1 means 50% slow.",
    type   = 'number',
    section= 'silly',
    def=1,
    min=0,
    max=1,
    step=0.01,
  },
  {
    key    = 'zombies_partial_reclaim',
    name   = 'Zombies partially reclaimable',
    desc   = "Partially reclaimed zombies are partially damaged.",
    type   = 'bool',
    section= 'silly',
    def = false,
  },
  {
    key = "max_com_level",
    name = "Commander level limit",
    desc = "Choose the commander level limit. 0 for unlimited.",
    type = "number",
    section= 'startconds',
    def = 0,
    min = 0,
    step = 1,
    max = 20,
  },
  {
	key		= "disabledunits",
	name	= "Disable units",
	desc	= "Prevents specified units from being built ingame. Specify multiple units by using + ",
	section	= 'startconds',
	type	= "string",
	def		= "",
  },
	{
		key = 'globallos',
		name = 'Full visibility',
		desc = 'No fog of war, everyone can see the entire map.',
		type = 'bool',
		section = 'startconds',
		def = false,
	},
  {
    key = "enablelagmonitor",
    name = "Inactive Player Unit Sharing",
    desc = "Whether to automatically share units of inactive players to another player within the team.",
    type   = "list",
    section= 'a_important',
    def    = "auto",
    items  = {
      {
        key  = "on",
        name = "Enable",
        desc = "Share units of inactive players.",
      },
      {
        key  = "auto",
        name = "PvP Only",
        desc = "Enable if there are at least two teams of non-AIs. Lagging or dropped players will still share units.",
      },
      {
        key  = "off",
        name = "Disable",
        desc = "Do not share units of inactive players. Lagging or dropped players will still share units.",
      },
    },
  },
  {
    key         = "allyreclaim",
    name        = "Reclaimable allies",
    desc        = "Allows reclaiming allied units and structures",
    type        = "bool",
    section     = "experimental",
    def         = false,
  },
  {
    key         = "reveal_superweapons",
    name        = "Reveal superweapons",
    desc        = "Reveals superweapons as soon as they exceed 5% completion.",
    type        = "bool",
    section     = "experimental",
    def         = false,
  },
  {
    key         = "artefact_control",
    name        = "Artefact Control",
    desc        = "Win the game by taking control of all the artefacts on the map.",
    type        = "bool",
    section     = "experimental",
    def         = false,
  },
  
  {
    key         = "techk",
    name        = "Tech-K",
    desc        = "Add a tech level system (don't work now)",
    type        = "bool",
    section     = "experimental",
    def         = false,
  },
  {
    key         = "disableresurrect",
    name        = "Disable resurrect",
    desc        = "Removes resurrect abilities from the game",
    type        = "bool",
    section     = "experimental",
    def         = false,
  },
  {
    key    = "equalcom",
    name   = "Equalize team commanders",
    desc   = "Give extra commanders to players on teams with fewer players, so that each team has the same number of commanders. Automatically enabled in 'Team' type rooms.",
    type   = "list",
    section= 'startconds',
    def    = "auto",
    items  = {
      {
        key  = "off",
        name = "Disabled",
        desc = "No extra commanders are spawned for smaller teams.",
      },
      {
        key  = "auto",
        name = "Autodetect",
        desc = "Spawn extra commanders for some players on the smaller team in the room type 'Team'.",
      },
      {
        key  = "enable",
        name = "Enabled",
        desc = "Spawn extra commanders for some players on smaller teams to make up the difference in team size.",
      },
    },
  },
  {
    key    = "shuffle",
    name   = "Start Boxes",
    desc   = "Start box settings.",
    type   = "list",
    section= 'startconds',
    def    = "auto",
    items  = {
      {
        key  = "off",
        name = "Fixed",
        desc = "Startboxes have a fixed correspondence to teams.",
      },
      {
        key  = "shuffle",
        name = "Shuffle",
        desc = "Shuffle among boxes that would be used.",
      },
      {
        key  = "allshuffle",
        name = "All Shuffle",
        desc = "Shuffle all present boxes.",
      },
      {
        key  = "auto",
        name = "Autodetect",
        desc = "Shuffle if FFA.",
      },
      {
        key  = "disable",
        name = "Start Anywhere",
        desc = "Allow to place anywhere. Boxes are still drawn for reference but are not obligatory.",
      },
    },
  },
  {
    key='setaispawns',
    name='Set AI Spawns',
    desc='Allow players to set the start positions of AIs.',
    type='bool',
    section= 'startconds',
    def=false,
  },
  {
    key='disable_ai_team_resign',
    name='Disable AI Resignation',
    desc='Prevents AIs from resigning when they run out of constructors and factories.',
    type='bool',
    section= 'a_important',
    def=false,
  },
  {
    key='disable_overwhelming_advantage',
    name='Disable Overwhelming Advantage',
    desc='Disable team reveal when the opposing team has 25x more assets.',
    type='bool',
    section= 'a_important',
    def=false,
  },
  {
    key='disable_local_widgets',
    name='Disable Local Widgets',
    desc='Disable loading of local widget.',
    type='bool',
    section= 'a_important',
    def=false,
  },
	{
		key = "noelo",
		name = "No Elo",
		desc = "Prevent battle from affecting Elo rankings",
		type = "bool",
		section= 'a_important',
		def = false,
	},

  {
    key='typemapsetting',
    name='No roads',
    desc='Some maps have roads that allow faster unit movement. When enabled, units will move at their regular unboosted speed on roads.',
    type='bool',
    section= 'mapsettings',
    def=false,
  },
  {
    key    = 'sudden_death_minutes',
    name   = 'Sudden Death Minutes',
    desc   = 'How many minutes until sudden death begins. This mode quickly determines a winner via a contracting death circle. Set -1 to disable.',
    type   = 'number',
    section= 'mapsettings',
    def    = -1,
    min    = -1,
    max    = 2000,
    step   = 1,
  },
  {
    key    = 'sudden_death_sweep_seconds',
    name   = 'Sudden Death Sweep Seconds',
    desc   = 'How many seconds it takes for the sudden death circle to contract to the centre of the map.',
    type   = 'number',
    section= 'mapsettings',
    def    = 60,
    min    = 1,
    max    = 9000,
    step   = 1,
  },
  { -- Might cause desync, check if they occur.
    key    = 'waterlevel',
    name   = 'Manual Water Level',
    desc   = 'How much to raise water level, in elmos.',
    type   = 'number',
    section= 'mapsettings',
    def    = 0,
    min    = -2000,
    max    = 2000,
    step   = 1,
  },
  {
    key    = 'waterpreset',
    name   = 'Water Level',
    desc   = 'Adjusts the water level of the map',
    type   = "list",
    section= 'mapsettings',
    def    = 'manual',
    items  = {
      {
        key  = "manual",
        name = "Manual",
        desc = "Input height manually",
      },
      {
        key  = "dry",
        name = "Dry",
        desc = "Drain the map of water",
      },
      {
        key  = "flooded",
        name = "Flooded",
        desc = "Cover half the map area with water",
      },
    },
  },
  {
    key    = 'metalmult',
    name   = 'Metal Extraction Multiplier',
    desc   = 'Multiplies metal extraction rate. For use in large team games when there are fewer mexes per player.',
    type   = 'number',
    section= 'multipliers',
    def    = 1,
    min    = 0,
    max    = 100,
    step   = 0.05,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  {
    key    = 'energymult',
    name   = 'Energy Production Multiplier',
    desc   = 'Useful for speed games without relying on map units.',
    type   = 'number',
    section= 'multipliers',
    def    = 1,
    min    = 0,
    max    = 100,
    step   = 0.05,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  {
    key    = 'experimental',
    name   = 'Experimental',
    desc   = 'Experimental.',
    type   = 'section',
  },
  {
    key = "overdrivesharingscheme",
    name = "Economy returns investment",
    desc = "Resource gathering buildings return their cost over time to the players who build them rather than equally to the whole team.",
    type = 'bool',
    section= 'experimental',
    def = true,
  },
  {
    key    = 'explodeondefeat',
    name   = 'Enemies explode on victory',
    desc   = 'Causes units and structures of defeated teams to explode when the game ends.',
    type   = 'bool',
    def    = true,
    section= 'experimental',
  },
  {
    key    = 'commends',
    name   = 'Team Commander Ends',
    desc   = 'Causes an allyteam to lose if they have no commanders left on their team',
    type   = 'bool',
    def    = false,
    section= 'experimental',
  },
  {
    key    = 'terrarestoreonly',
    name   = 'Terraform Restore Only',
    desc   = 'Restore is the only terraform option available.',
    type   = 'bool',
    section= 'experimental',
    def    = false,
  },
  {
    key    = 'enemyterra',
    name   = 'Allow Terraform Near Enemies',
    desc   = 'Without this option terraform progress is 20x slower if an enemy unit is visible nearby.',
    type   = 'bool',
    section= 'experimental',
    def    = false,
  },
  {
    key    = 'mtpath',
    name   = 'Multithread Pathfinding',
    desc   = 'Use multiple cores for pathfinding calculations.',
    type   = 'bool',
    section= 'experimental',
    def    = true,
  },
  {
    key    = 'terracostmult',
    name   = 'Terraform Cost Multiplier',
    desc   = 'Multiplies the cost of terraform.',
    type   = 'number',
    section= 'multipliers',
    def    = 1,
    min    = 0.01,
    max    = 100,
    step   = 0.01,
  },
  {
    key    = 'shield_merge',
    name   = 'Shield type',
    desc   = 'Shield merge method.',
    type   = 'list',
    section= 'experimental',
    def    = 'none',
    items = {
      {key = 'none', name = "Default", desc = 'Shield link only'},
      {key = 'share', name = "Impact sharing", desc = 'On impact, neighbours contribute charge to make up the required charge.'},
      {key = 'penetrate', name = "Partial Penetrate", desc = 'Projectiles drain shields that they penetrate but lose effective damage for subsequent shield impacts.'},
    },
  },
  {
    key     = "tweakunits",
    name    = "Tweak Units",
    desc    = "A base64 encoded lua table of unit parameters to change.",
    section = 'experimental',
    type    = "string",
    def     = "",
  },
  {
    key     = "tweakdefs",
    name    = "Tweak Defs",
    desc    = "A base64 encoded snippet of code that modifies game definitions.",
    section = 'experimental',
    type    = "string",
    def     = "",
  },
  {
    key     = "option_notes",
    name    = "Notes",
    desc    = "A message that is displayed at the start of the game.",
    section = 'experimental',
    type    = "string",
    def     = "",
  },
--[[
  {
    key    = 'damagemult',
    name   = 'Damage Multiplier',
    desc   = 'Multiplies the damage dealt by all weapons, except for D-guns; autoheal; repair; and capture.',
    type   = 'number',
    section= 'experimental',
    def    = 1,
    min    = 0.01,
    max    = 10,
    step   = 0.01,
  },
  {
    key    = 'unitspeedmult',
    name   = 'Unit Speed Multiplier',
    desc   = 'Multiplies the speed, acceleration, and turn rate of all units.',
    type   = 'number',
    section= 'experimental',
    def    = 1,
    min    = 0.01,
    max    = 10,
    step   = 0.01,
  },
]]--
   {
    key = "startmetal",
    name = "Starting metal",
    desc = "Set each player's starting metal. -1 for default.",
    type = "number",
    section= 'startconds',
    def = -1,
    min = -1,
    step = 1,
    max = 10000,
  },
  {
    key = "startenergy",
    name = "Starting energy",
    desc = "Set each player's starting energy. -1 for default.",
    type = "number",
    section= 'startconds',
    def = -1,
    min = -1,
    step = 1,
    max = 10000,
  },
  {
    key = "startresdelta",
    name = "Starting resources variation",
    desc = "Add a random number between 0 and this modoption to starting resources. Consistent for all players.",
    type = "number",
    section= 'startconds',
    def = 0,
    min = 0,
    step = 1,
    max = 500,
  },
  {
    key = "innatemetal",
    name = "Innate metal income",
    desc = "Set each player's innate metal income, max 20, -1 for default",
    type = "number",
    section= 'startconds',
    def = -1,
    min = -1,
    step = 0.01,
    max = 10000,
  },
  {
    key = "innateenergy",
    name = "Innate energy income",
    desc = "Set each player's innate energy income, max 20, -1 for default",
    type = "number",
    section= 'startconds',
    def = -1,
    min = -1,
    step = 0.01,
    max = 10000,
  },
  {
    key    = 'cratermult',
    name   = 'Cratering Multiplier',
    desc   = 'Multiplies the depth of craters.',
    type   = 'number',
    section= 'multipliers',
    def    = 1,
    min    = 0,
    max    = 1000,
    step   = 0.01,
  },
  {
    key    = 'hpmult',
    name   = 'Unit Health Multiplier',
    desc   = 'Multiplies all unit HPs.',
    type   = 'number',
    section= 'multipliers',
    def    = 1,
    min    = 0.000001,
    max    = 10000,
    step   = 0.05,
  },
  {
    key    = 'xmas',
    name   = 'Enable festive units',
    desc   = "Zero K units get into the spirit of the season with a festive new look.",
    type   = 'bool',
    section= 'silly',
    def    = false,
  },
  {
    key    = 'allowfpsmode',
    name   = 'Enable first person control',
    desc   = "Allow players to take direct control of units without cheats enabled. Select a unit and press Alt+P to toggle.",
    type   = 'bool',
    section= 'silly',
    def    = false,
  },
	{
		key     = 'maxunits',
		name    = 'Max units',
		desc    = 'Determines how many units and buildings a player is allowed to own at a time',
		type    = 'number',
		section = 'multipliers',
		def     = 10000, -- don't change to anything reachable, won't take effect; engine default is ~10K
		                 -- (actually 32K / #teams so 1v1+gaia allows ~10K each)
		min     = 10,
		max     = 10000,
		step    = 10,
	},
	{
		key     = 'minspeed',
		name    = 'Minimum game speed',
		desc    = 'Sets the minimum speed that the players will be allowed to change to',
		type    = 'number',
		section = 'multipliers',
		def     = 0.3, -- don't change, won't take effect as this is engine value
		min     = 0.1,
		max     = 2.0,
		step    = 0.1,
	},
	{
		key     = 'maxspeed',
		name    = 'Maximum game speed',
		desc    = 'Sets the maximum speed that the players will be allowed to change to',
		type    = 'number',
		section = 'multipliers',
		def     = 20.0, -- don't change, won't take effect as this is engine value
		min     = 0.5,
		max     = 20.0,
		step    = 0.1,
	},
	{
		key     = 'team_1_econ',
		name    = 'Team 1 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'team_2_econ',
		name    = 'Team 2 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'team_3_econ',
		name    = 'Team 3 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'team_4_econ',
		name    = 'Team 4 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'team_5_econ',
		name    = 'Team 5 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'team_6_econ',
		name    = 'Team 6 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'team_7_econ',
		name    = 'Team 7 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'team_8_econ',
		name    = 'Team 8 Income Multiplier',
		desc    = 'Multiplies metal, energy and build speed. Set above 1 for an advantage and below 1 for a disadvantage.',
		type    = 'number',
		section = 'multipliers',
		def     = 1,
		min     = 0.01,
		max     = 100,
		step    = 0.01,
	},
	{
		key     = 'autohandicap',
		name    = 'Automatic Handicap',
		desc    = 'Add automatically calculated economy multipliers for team 1 or 2 depending on rating.',
		type    = 'bool',
		section = 'multipliers',
		def     = false,
	},
	{
		key     = 'disablemapdamage',
		name    = 'Disable map deformation',
		desc    = 'Prevents the map shape from being changed by weapons and terraforming',
		type    = 'bool',
		section = 'mapsettings',
		def     = false, -- don't change, won't take effect as this is engine value
	},
	{
		key     = 'mapgen_seed',
		name    = 'Random Map Seed',
		desc    = 'Random seed for random map generation. A random map must be selected from the map list.',
		type    = 'number',
		section = 'mapsettings',
		def     = 0,
		min     = 0,
		max     = 10000000,
		step    = 1,
	},
  {
    key         = "capture_full_override",
    name        = "Capture Full Override",
    desc        = "If a unit is captured ",
    type        = "bool",
    section     = "experimental",
    def         = true,
  },
	{
		key     = "allyteam_long_name_1",
		name    = "Team 1 Name Override",
		desc    = "Overrides the name of team 1 in the player list.",
		section = 'mapsettings',
		type    = "string",
		def     = "",
	},
	{
		key     = "allyteam_short_name_1",
		name    = "Team 1 Short Name Override",
		desc    = "Overrides the short name of team 1 on the spectator panels.",
		section = 'mapsettings',
		type    = "string",
		def     = "",
	},
	{
		key     = "allyteam_long_name_2",
		name    = "Team 2 Name Override",
		desc    = "Overrides the name of team 2 in the player list.",
		section = 'mapsettings',
		type    = "string",
		def     = "",
	},
	{
		key     = "allyteam_short_name_2",
		name    = "Team 2 Short Name Override",
		desc    = "Overrides the short name of team 2 on the spectator panels.",
		section = 'mapsettings',
		type    = "string",
		def     = "",
	},
	--[[ Engine option, would need proper UI before enabling
	{
		key     = 'fixedallies',
		name    = 'Disallow ceasefire',
		desc    = 'Is ceasefire banned? For FFA.',
		type    = 'bool',
		section = 'experimental',
		def     = true, -- don't change, won't take effect as this is engine value
	},
	]]

  --{
  --  key		= "enableunlocks",
  --  name	= "Enable unlock system",
  --  desc	= "Enables the unlock system (disabling will enable all units by default)",
  --  type	= "bool",
  --  def		= true,
  --  section	= "experimental",
  --},
--  { -- Causes desync https://springrts.com/mantis/view.php?id=5936
--    key		= "pathfinder",
--    name	= "Pathfinder type",
--    desc	= "Sets the pathfinding system used by units.",
--    type	= "list",
--    def		= "standard",
--    section	= "experimental",
--    items  = {
--      {
--	key  = 'standard',
--	name = 'Standard',
--	desc = 'Standard pathfinder',
--      },
--      {
--	key  = 'qtpfs',
--	name = 'QTPFS',
--	desc = 'New Quadtree Pathfinding System (experimental)',
--      },
--    --  {
--	--	key  = 'classic',
--	--	name = 'Classic',
--	--	desc = 'An older pathfinding system without turninplace or reverse',
--    --  }
--    },
--  },
  
  {
    key    = 'chicken',
    name   = 'Chicken',
    desc   = 'Settings for Chicken: Custom',
    type   = 'section',
  },
  {
    key    = 'chickenailevel',
    name   = 'Chicken AI Difficulty',
    desc   = "Option for automatically adding an AI to the script. Implemented by Springies and Chobby.",
    type   = 'list',
    section= 'chicken',
    def    = 'none',
    items = {
      { key = 'none', name = "none", desc = 'No chickens at all.' },
      { key = 'Chicken: Very Easy', name = "Chicken: Very Easy", desc = 'Very Easy Chicken.' },
      { key = 'Chicken: Easy', name = "Chicken: Easy", desc = 'Easy Chicken.' },
      { key = 'Chicken: Normal', name = "Chicken: Normal", desc = 'Normal Chicken.' },
      { key = 'Chicken: Hard', name = "Chicken: Hard", desc = 'Hard Chicken.' },
      { key = 'Chicken: Suicidal', name = "Chicken: Suicidal", desc = 'Suicidal Chicken.' },
      { key = 'Chicken: Custom', name = "Chicken: Custom", desc = 'Customize your chicken.' },
    },
  },
--[[ broken, prevent newbie footgun (cf. #3567 gameside ticket)
  {
    key = "playerchickens",
    name = "Players as chickens",
    desc = "Shared chickens with players, take commanders away",
    type = "bool",
    def = false,
    section = 'chicken',
  },
]]
  {
    key	= "eggs",
    name = "Chicken Eggs",
    desc = "Enables eggs mode (applies to all chicken difficulties); metal extractors are disabled but chickens drop twice as many eggs",
    type = "bool",
    def	= false,
    section = 'chicken',
  },
  {
    key	= "speedchicken",
    name = "Speed Chicken",
    desc = "Game lasts half as long; no miniqueens (applies to all chicken difficulties)",
    type = "bool",
    def	= false,
    section = 'chicken',
  },
  {
    key    = 'chickenspawnrate',
    name   = 'Chicken Spawn Rate',
    desc   = 'Sets the frequency of chicken waves in seconds.',
    type   = 'number',
    section= 'chicken',
    def    = 50,
    min    = 5,
    max    = 200,
    step   = 1,
  },
  {
    key    = 'burrowspawnrate',
    name   = 'Burrow Spawn Rate',
    desc   = 'Sets the frequency of burrow spawns in seconds (modified by playercount and number of existing burrows).',
    type   = 'number',
    section= 'chicken',
    def    = 45,
    min    = 1,
    max    = 200,
    step   = 1,
  },
  {
    key    = 'wavesizemult',
    name   = 'Wave size mult',
    desc   = 'Increases or decreases the size of each chicken wave.',
    type   = 'number',
    section= 'chicken',
    def    = 1,
    min    = 0.1,
    max    = 40,
    step   = 0.05,
  },
  {
    key    = 'queentime',
    name   = 'Queen Time',
    desc   = 'How soon the queen appears on her own, minutes.',
    type   = 'number',
    section= 'chicken',
    def    = 60,
    min    = 1,
    max    = 300,
    step   = 1,
  },
  {
    key    = 'queenhealthmod',
    name   = 'Queen Health Mult',
    desc   = 'Queen health multiplier',
    type   = 'number',
    section= 'chicken',
    def    = 1,
    min    = 0.1,
    max    = 1000, --[[ keep in mind that this can get further increased by playercount-based mults,
                        and that at such extreme values float errors appear (uncharted territory) ]]
    step   = 0.05,
  },
  {
    key     = 'chicken_endless',
    name    = 'Infinite Chicken',
    desc    = 'Queen does not spawn, waves go on forever.',
    type    = "bool",
    def     = false,
    section = 'chicken',
  },
  {
    key    = 'graceperiod',
    name   = 'Grace Period',
    desc   = 'Delay before the first wave appears, minutes.',
    type   = 'number',
    section= 'chicken',
    def    = 2.5,
    min    = 0,
    max    = 120,
    step   = 0.5,
  },
  {
    key    = 'miniqueentime',
    name   = 'Dragon Time',
    desc   = 'Time when the White Dragons appear, as a proportion of queen time. 0 disables.',
    type   = 'number',
    section= 'chicken',
    def    = 0.6,
    min    = 0,
    max    = 1,
    step   = 0.05,
  },
  {
    key    = 'techtimemult',
    name   = 'Tech Time Mult',
    desc   = 'Multiplier for the appearance times of advanced chickens.',
    type   = 'number',
    section= 'chicken',
    def    = 1,
    min    = 0,
    max    = 5,
    step   = 0.05,
  },
  {
    key    = 'chicken_maxtech',
    name   = 'Max Tech Level',
    desc   = 'Maximum timer for chicken tech level progression, in seconds. Lowering this value will exclude some or most chicken types. Applies to all difficulties.',
    type   = 'number',
    section= 'chicken',
    def    = 9000,
    min    = 0,
    max    = 9000,
    step   = 60,
  },
--[[
  {
	key    = 'burrowtechtime',
	name   = 'Burrow Tech Time',
	desc   = 'How much time each burrow shaves off chicken appearance times per wave (divided by playercount), seconds',
	type   = 'number',
	section= 'chicken',
	def    = 12,
	min    = 0,
	max    = 60,
	step   = 1,
  },
]]--
  {
	key    = 'burrowqueentime',
	name   = 'Burrow Queen Time',
	desc   = 'How much time each burrow death subtracts from queen appearance time, seconds.',
	type   = 'number',
	section= 'chicken',
	def    = 15,
	min    = 0,
	max    = 120,
	step   = 1,
  },
}

for i = 1, 9 do
	options[#options + 1] =  {
		key     = "tweakunits" .. i,
		name    = "Tweak Units " .. i,
		desc    = "A base64 encoded lua table of unit parameters to change.",
		section = 'experimental',
		type    = "string",
		def     = "",
		noLobby = true,
	}
end

for i = 1, 9 do
	options[#options + 1] =  {
		key     = "tweakdefs" .. i,
		name    = "Tweak Defs " .. i,
		desc    = "A base64 encoded snippet of code that modifies game definitions.",
		section = 'experimental',
		type    = "string",
		def     = "",
		noLobby = true,
	}
end

--// add key-name to the description (so you can easier manage modoptions in springie)
for i=1,#options do
  local opt = options[i]
  opt.desc = opt.desc .. '\nkey: ' .. opt.key
end

return options
