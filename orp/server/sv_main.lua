AddEvent("OnPackageStart", function()
	print("")
	print("-------------------------------")
	print("O:RP - Made by Dimmies | v" .. ORP_VERSION)
	print("-------------------------------")
	print("")

	if AUTO_START_PACKAGES == true then
		if DEBUG_MODE == true then print("AUTO_START_PACKAGES Enabled, Starting all ORP packages!") end
		AutoLoadPackages()
	end
end)

PlayerData = {}

AddEvent("OnPlayerSteamAuth", function(player)
	local SteamID = tostring(GetPlayerSteamId(player))
	if DEBUG_MODE then print(SteamID .. " is joining server!") end
	if ENABLE_WHITELIST == true then
		CheckWhitelist(player)
	else
		CheckBan(player)
	end
end)

AddEvent("OnPlayerQuit", function(player)
	UpdatePlayerData(player)
	Delay(100, function()
		PlayerData[player] = nil
	end)
end)

function CheckWhitelist(player)
	local SteamID = tostring(GetPlayerSteamId(player))
	if DEBUG_MODE then print("Checking if " .. SteamID .. " is whitelisted..") end
	mariadb_query(sql, mariadb_prepare(sql, "SELECT * FROM whitelist WHERE steamid = '?'", SteamID), function(player)
        if mariadb_get_row_count() >= 1 then
			CheckBan(player)
		else
			KickPlayer(player, _('not_whitelisted'))
		end
	end, player)
end

function CheckBan(player)
	local SteamID = tostring(GetPlayerSteamId(player))
	if DEBUG_MODE then print("Checking if " .. SteamID .. " is banned..") end
	mariadb_query(sql, mariadb_prepare(sql, "SELECT * FROM bans WHERE steamid = '?'", SteamID), function(player)
		if mariadb_get_row_count() >= 1 then
			local result = mariadb_get_assoc(1)
			if tonumber(result['perm']) == 0 then
				if tonumber(result['expire']) < os.time() then
					mariadb_query(sql, mariadb_prepare(sql, "DELETE FROM bans WHERE steamid = '?'", SteamID))
					LoadPlayer(player)
				else
					Delay(1000, function()
						print(SteamID .. " was disconnected. [Banned!]")
						local expireTime = os.date("%c", tonumber(result['expire']))
						KickPlayer(player, "You were temporarily banned \n Reason: " .. tostring(result['reason']) .. " \n Expires: " .. expireTime .. " \n Admin: " .. tostring(result['admin']))
					end)
				end
			else
				Delay(1000, function()
					print(SteamID .. " was disconnected. [Banned!]")
					KickPlayer(player, "You were banned permanently \n Reason: " .. tostring(result['reason']) .. " \n Admin: " .. tostring(result['admin']))
				end)
			end
		else
			LoadPlayer(player)
		end
	end, player)
end

function LoadPlayer(player)
	local SteamID = tostring(GetPlayerSteamId(player))
	mariadb_query(sql, mariadb_prepare(sql, "SELECT * FROM accounts WHERE steamid = '?'", SteamID), function(player)
		if mariadb_get_row_count() >= 1 then
			LoadPlayerData(player)
		else
			CreatePlayerData(player)
		end
	end, player)
	CallRemoteEvent(player, "ToggleHud", SHOW_HEALTH_HUD, SHOW_WEAPON_HUD)
end

function LoadPlayerData(player)
	local SteamID = tostring(GetPlayerSteamId(player))
	if DEBUG_MODE then print("Loading Player Data for " .. SteamID) end
	PlayerData[player] = {}
	mariadb_query(sql, mariadb_prepare(sql, "SELECT * FROM accounts WHERE steamid = ?", SteamID), function(player)
		local result = mariadb_get_assoc(1)
		for i=1, mariadb_get_field_count(), 1 do
			PlayerData[player][mariadb_get_field_name(i)] = result[mariadb_get_field_name(i)]
		end

		if RANDOM_SPAWN == true then
			math.randomseed(os.clock())
			local rloc = math.random(1, #R_Locations)
			SetPlayerLocation(player, R_Locations[rloc].x, R_Locations[rloc].y, R_Locations[rloc].z)
		elseif RESPAWN_LASTLOC == true then
			local loc = json_decode(result['location'])
			SetPlayerLocation(player, loc[1], loc[2], loc[3])
		elseif RANDOM_SPAWN == false and RESPAWN_LASTLOC == false then
			SetPlayerLocation(player, SPAWN_LOCATION.x, SPAWN_LOCATION.y, SPAWN_LOCATION.z)
		end
		
		if SAVE_HEALTH == true then
			SetPlayerHealth(player, tonumber(result['health']))
		elseif SAVE_HEALTH == false then
			if RESPAWN_HEALTH > 0 then
				SetPlayerHealth(player, RESPAWN_HEALTH)
			else
				print("RESPAWN_HEALTH is set to 0 > increase this!")
			end
		end

		if SAVE_ARMOR == true then
			SetPlayerArmor(player, tonumber(result['armor']))
		elseif SAVE_ARMOR == false then
			if RESPAWN_ARMOR > 0 then
				SetPlayerArmor(player, RESPAWN_ARMOR)
			else
				print("RESPAWN_ARMOR is set to 0 > increase this!")
			end
		end

		if SAVE_DEAD == true then
			if PlayerData[player].isdead == 1 then
				Delay(6000, function()
					SetPlayerRespawnTime(player, 100)
					SetPlayerHealth(player, 100)
					Delay(200, function()
						SetPlayerHealth(player, 0)
					end)
				end)
			end
		end
	end, player)
end

function CreatePlayerData(player)
	local SteamID = tostring(GetPlayerSteamId(player))
	if DEBUG_MODE then print("Creating Player Data for " .. SteamID) end

	mariadb_query(sql, mariadb_prepare(sql, "INSERT INTO accounts (steamid) VALUES ('?')", SteamID), function(player)
		if (mariadb_get_affected_rows() >= 1) then
			PlayerData[player].adminlevel = 0
			PlayerData[player].cash = START_CASH
			PlayerData[player].bank = START_BANK
			PlayerData[player].dirtymoney = 0
			PlayerData[player].job = "unemployed"
			PlayerData[player].jobrank = 0
			PlayerData[player].health = 100
			PlayerData[player].armor = 0
			PlayerData[player].isdead = 0
			PlayerData[player].sex = ""
		
			local x, y, z = GetPlayerLocation(player)
			local loc = { x, y, z }
			mariadb_query(sql, mariadb_prepare(sql, "UPDATE accounts SET adminlevel = '?', cash = '?', bank = '?', dirtymoney = '?', job = '?', jobrank = '?', location = '?', health = '?', armor = '?', isdead = '?', sex = '?' WHERE steamid = '?'",
				PlayerData[player].adminlevel,
				PlayerData[player].cash,
				PlayerData[player].bank,
				PlayerData[player].dirtymoney,
				PlayerData[player].job,
				PlayerData[player].jobrank,
				json_encode(loc),
				PlayerData[player].health,
				PlayerData[player].armor,
				PlayerData[player].isdead,
				PlayerData[player].sex,
				SteamID
			))
		end
	end, player)
	SetPlayerLocation(player, SPAWN_LOCATION.x, SPAWN_LOCATION.y, SPAWN_LOCATION.z)
end

function UpdatePlayerData(player)
    SteamID = tostring(GetPlayerSteamId(player)) 
	if DEBUG_MODE == true then print("Updating Player Data for " .. SteamID) end
    x, y, z = GetPlayerLocation(player)
	loc = { x, y, z }
    
	if not PlayerData[player] then return end
	if DEBUG_MODE == true then print(json_encode(PlayerData[player])) end
    mariadb_query(sql, mariadb_prepare(sql, "UPDATE accounts SET adminlevel = '?', cash = '?', bank = '?', dirtymoney = '?', job = '?', jobrank = '?', location = '?', health = '?', armor = '?', isdead = '?', sex = '?' WHERE steamid = '?'",
        PlayerData[player].adminlevel,
        PlayerData[player].cash,
		PlayerData[player].bank,
		PlayerData[player].dirtymoney,
        PlayerData[player].job,
        PlayerData[player].jobrank,
        json_encode(loc),
        GetPlayerHealth(player),
        GetPlayerArmor(player),
		PlayerData[player].isdead,
		PlayerData[player].sex,
        SteamID
    ))
end
AddRemoteEvent("UpdatePlayerData", UpdatePlayerData)
AddFunctionExport("UpdatePlayerData", UpdatePlayerData)

-- // Experimental Auto-Load Packages
function AutoLoadPackages()
	dir = "packages" -- Directory to where all of your packages are. You shouldn't have to change this
    local i, t, popen = 0, {}, io.popen
    for filename in popen('dir "'..dir..'" /b'):lines() do
		if string.match(filename, "orp_") then
			StartPackage(filename)
			if DEBUG_MODE == true then print("Auto-Started " .. filename) end
		end
        i = i + 1
        t[i] = filename
    end
    return t
end

-- Weather/Time Timer w/ Sync
local currentTime = 8

AddEvent("OnPackageStart", function()
    currentTime = 8
    for k,v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "SyncTime", 8)
    end
    StartTimeTimer()
end)

function StartTimeTimer()
    CreateTimer(function()
        if currentTime >= 24 then
            currentTime = 0
        else
            currentTime = currentTime + 0.03
        end
        SyncWeatherTime()
    end, 5000)
end

function SyncWeatherTime()
    for k,v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "SyncTime", currentTime)
        CallRemoteEvent(v, "SyncWeather", DEFAULT_WEATHER)
    end
end

function SetServerTime(player, time)
    currentTime = time
    SyncWeatherTime()
end
AddEvent("SetServerTime", SetServerTime)

function BanPlayer(player, plySteam, reason, type, duration)
	local banReason = reason or _('def_ban_reason')
	local currentTime = os.time()
	local currentDate = os.date()
	local banDuration = -1
	local isPerm = 0

	if type == "hour" or type == "h" then
		banDuration = math.tointeger(duration) * 3600 + currentTime or DEFAULT_TEMPBAN_TIME * 3600 + currentTime
	elseif type == "day" or type == "d" then
		banDuration = math.tointeger(duration) * 86400 + currentTime or DEFAULT_TEMPBAN_TIME * 86400 + currentTime
	elseif type == "month" or type == "m" then
		banDuration = math.tointeger(duration) * 2628000 + currentTime or DEFAULT_TEMPBAN_TIME * 2628000 + currentTime
	elseif type == "perm" or type == "p" then
		banDuration = -1
		isPerm = 1
	end

	mariadb_query(sql, mariadb_prepare(sql, "INSERT INTO bans (steamid, expire, reason, date, admin, perm) VALUES ('?', '?', '?', '?', '?', '?')", plySteam, tostring(banDuration), banReason, currentDate, GetPlayerName(player), isPerm))
	if isPerm == 0 then
		print(GetPlayerSteamId(player) .. " banned " .. plySteam .. " for " .. duration .. type .. " for " .. banReason)
		KickPlayer(player2, "You were temporarily banned \n Reason: " .. banReason .. " \n Expires: " .. os.date("%I %c", banDuration) .. " \n Admin: " .. GetPlayerName(player))
	else
		print(GetPlayerSteamId(player) .. " banned " .. plySteam .. " permanently for " .. banReason)
		KickPlayer(player2, "You were banned permanently \n Reason: " .. banReason .. " \n Admin: " .. GetPlayerName(player))
	end
end

function UpdatePlayerHud(player, type, data)
	CallRemoteEvent(player, "ORP:UpdateUIJS", type, data)
end
AddRemoteEvent("ORP:UpdatePlayerHud", UpdatePlayerHud)

function FetchUIInfo(player)
	local cashdata = PlayerData[player].cash
	local bankdata = PlayerData[player].bank
	local dirtydata = PlayerData[player].dirtymoney
	local jobdata = { PlayerData[player].job, PlayerData[player].jobrank }
	CallRemoteEvent(player, "ORP:UpdateUIJS", "cash", cashdata)
	CallRemoteEvent(player, "ORP:UpdateUIJS", "bank", bankdata)
	CallRemoteEvent(player, "ORP:UpdateUIJS", "dirty", dirtydata)
	CallRemoteEvent(player, "ORP:UpdateUIJS", "job", jobdata)
end
AddRemoteEvent("ORP:FetchUIInfo", FetchUIInfo)

function UndergoundTP(player, x, y, z, th)
    SetPlayerLocation(player, x, y, th + 200)
end
AddRemoteEvent("UndergoundTP", UndergoundTP)

function GetPlayerInfo(player)
	for k,v in pairs(GetAllPlayers()) do
		local _name = GetPlayerName(v)
		local _steam = tostring(GetPlayerSteamId(v))
		local _ping = GetPlayerPing(v)
		CallRemoteEvent(player, "ORP:SendPlayerInfoJS", v, _name, _steam, _ping)
	end
end
AddRemoteEvent("ORP:GetPlayerInfo", GetPlayerInfo)