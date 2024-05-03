if SERVER then AddCSLuaFile() end
local LOCALISATION = {}
LOCALISATION["english"] = {
    ["GM_DIFFICULTY"] = "Difficulty level",
    ["GM_DIFFICULTY_DESC"] = "Set the gametype difficulty",
    ["GM_WALKSPEED"] = "Walk speed",
    ["GM_WALKSPEED_DESC"] = "Set speed when slowly walking with ALT key",
    ["GM_NORMSPEED"] = "Normal speed",
    ["GM_NORMSPEED_DESC"] = "Set speed normal walk speed",
    ["GM_SPRINTSPEED"] = "Sprint speed",
    ["GM_SPRINTSPEED_DESC"] = "Set running speed",
    ["GM_CONNECTTIMEOUT"] = "Connection timeout",
    ["GM_CONNECTTIMEOUT_DESC"] = "Set how long should it wait for connecting players",
    ["GM_PLAYERCOLLISION"] = "Player collision",
    ["GM_PLAYERCOLLISION_DESC"] = "Players can collide with other players",
    ["GM_FRIENDLYFIRE"] = "Friendly fire",
    ["GM_FRIENDLYFIRE_DESC"] = "Enable damage to other players",
    ["GM_PREVENTITEMMOVE"] = "Prevent item moving",
    ["GM_PREVENTITEMMOVE_DESC"] = "Prevent items from moving when shooting at them",
    ["GM_DEFAMMO"] = "Limit default ammo",
    ["GM_DEFAMMO_DESC"] = "Disable ammo limits",
    ["GM_AUTOJUMP"] = "Allow auto jump",
    ["GM_AUTOJUMP_DESC"] = "Allow players to use the auto jump feature",
    ["GM_RESPAWNTIME"] = "Respawn time",
    ["GM_RESPAWNTIME_DESC"] = "Set players respawn time",
    ["GM_CHECKPOINT_RESPAWN"] = "Checkpoint respawn",
    ["GM_CHECKPOINT_RESPAWN_DESC"] = "Players have to wait for checkpoints in order to respawn",
    ["GM_RESTARTTIME"] = "Restart time",
    ["GM_RESTARTTIME_DESC"] = "Set time between round ending and starting",
    ["GM_MAPCHANGETIME"] = "Mapchange time",
    ["GM_MAPCHANGETIME_DESC"] = "Set time after between map finish and level change",
    ["GM_CHECKPOINTTIMEOUT"] = "Checkpoint timeout",
    ["GM_CHECKPOINTTIMEOUT_DESC"] = "Set how long checkpoints wait for other players",
    ["GM_GODMODE"] = "Godmode",
    ["GM_GODMODE_DESC"] = "Enable god mode, prevents any damage",
    ["GM_PICKUPDELAY"] = "Pickup delay",
    ["GM_PICKUPDELAY_DESC"] = "Set weapon/item delay before picking it up",
    ["GM_DIFFMETRICS"] = "NPC/Player metrics",
    ["GM_DIFFMETRICS_DESC"] = "Metrics for use by developers",
    ["GM_WEAPONDROP"] = "Weapon drop mode",
    ["GM_WEAPONDROP_DESC"] = "Change what players drop on death",
    ["GM_CHANGELVLDELAY"] = "Level change delay",
    ["GM_CHANGELVLDELAY_DESC"] = "The amount in seconds to wait before changing to the next map",
    ["GM_COCKROACHES"] = "Cockroach amount",
    ["GM_COCKROACHES_DESC"] = "The maximum amount of cockroaches that can be spawned. 0 to disable them",
    ["GM_ABH"] = "Accelerated backhopping",
    ["GM_ABH_DESC"] = "Enable ABH, widely used by speedrunners to achieve insane speed",
    ["GM_DYNCHECKPOINT"] = "Dynamic checkpoints",
    ["GM_DYNCHECKPOINT_DESC"] = "Enable dynamic checkpoints",
    ["GM_NPCDMG"] = "Friendly NPC damage",
    ["GM_NPCDMG_DESC"] = "Allows friendly NPC to take damage",
    ["GM_PLYTRACK"] = "Player tracking",
    ["GM_PLYTRACK_DESC"] = "Allows seeing players through walls",
    ["GM_ANTLIONCOLLISION"] = "Friendly antlion collision",
    ["GM_ANTLIONCOLLISION_DESC"] = "Enable/disable colliding with friendly antlions",
    ["GM_PLAYERSPEECH"] = "Player speech",
    ["GM_PLAYERSPEECH_DESC"] = "Enable/disable players speaking based on performance",
    ["GM_PLAYERHURTSOUNDS"] = "Player damage speech",
    ["GM_PLAYERHURTSOUNDS_DESC"] = "Enable/disable players speaking based on recieved damage",
    ["GM_DM_FRAGLIMIT"] = "Score limit",
    ["GM_DM_FRAGLIMIT_DESC"] = "Set score limit for round to end",
    ["GM_DM_TIMELIMIT"] = "Round time limit",
    ["GM_DM_TIMELIMIT_DESC"] = "Set how long the round lasts",
    ["GM_DM_TEAMONLY"] = "Team based deathmatch",
    ["GM_DM_TEAMONLY_DESC"] = "Switch between DM or TDM",
}
return LOCALISATION