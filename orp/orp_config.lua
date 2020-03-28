--[[ 
	ORP Config 
	⚠ READ THE COMMENTS ⚠
	v1.0.0
--]]

ORP_VERSION = "1.0.0" -- Don't change this
DEBUG_MODE = true -- Enable this for additional logging to help debug any issues

SERVER_NAME = "O:RP Server" -- Change this to your server name
ENABLE_WHITELIST = false -- Set this to true to enable whitelisting
SERVER_LANGUAGE = "en" -- Used to detirmine what language to use

DEFAULT_TEMPBAN_TIME = 60000 -- The amount of time someone is temp banned if no specific time is set | Default: 1 Day

RANDOM_SPAWN = false -- Set this to true to enable random spawn locations each time a player joins
RESPAWN_LASTLOC = true -- Determines whether or not to spawn the player at the location they logged out at
SPAWN_LOCATION = {["x"] = 1, ["y"] = 1, ["z"] = 1500} -- This is the spawn location for when a player joins for the first time ⚠ Ignored if RANDOM_SPAWN is true! ⚠

SAVE_HEALTH = true -- If players spawn in with the last health they had before logging out
SAVE_ARMOR = true -- If players spawn in with the last armor they had before logging out
RESPAWN_HEALTH = 100 -- The health players spawn with ⚠ Ignored if SAVE_HEALTH is true! ⚠
RESPAWN_ARMOR = 100 -- The armor players spawn with ⚠ Ignored if SAVE_ARMOR is true! ⚠

START_CASH = 1000 -- How much Cash new players start with
START_BANK = 5000 -- How much Bank new players start with

SAVE_DEAD = true -- Whether or not the player should spawn dead if they logged out while dead

AUTO_SAVE_TIMER = 300000 -- How often players data should automatically save in ms | Default: 5 Minutes

AUTO_START_PACKAGES = true -- Whether or not O:RP should automatically start any packages | Must be named orp_<packagename> EX: orp_vehicles | This is experimental, it may not work

SHOW_NAME_TAG = true -- Whether or not name tags above players show
SHOW_HEALTH_TAG = true -- Whether or not health tags above players show
SHOW_ARMOR_TAG = true -- Whether or not armor tags above players show
SHOW_VOICE_TAG = true -- Whether or not voice tags above players show

SHOW_HEALTH_HUD = false -- Whether or not the Health HUD element should be shown | Default: false [Replaced with Player Cash/Bank/Job]
SHOW_WEAPON_HUD = false -- Whether or not the Weapon HUD element should be shown | Default: false [Replaced with Player Cash/Bank/Job]

DEFAULT_WEATHER = 7 -- Sets the default weather to sync all clients together | Weather System coming soon!

ENABLE_CHANGE_VIEW = true -- If players should be allowed to switch camera views (First Person/3rd Person)

ENABLE_HELP_COMMAND = true -- If the /help command should be enabled for all users.
HELP_COMMAND_SITE = "" -- The website/link players see when they run the /help command! | Admins will always see the O:RP Wiki

ENABLE_OOC_CHAT = true -- Set to false to disable the /ooc command | If enabled /ooc <msg> will send a message to all players
ENABLE_ME_CHAT = true -- Set to false to disable the /me command
ENABLE_DO_CHAT = true -- Set to false to disable the /do command
ENABLE_LOCAL_CHAT = true -- If enabled, all (non-command) messages will be sent to players in the vicinity of the sender. Use LOCAL_CHAT_RANGE to set the range.
LOCAL_CHAT_RANGE = 250 -- The range that local chats are sent to ⚠ Ignored if ENABLE_LOCAL_CHAT is false! ⚠