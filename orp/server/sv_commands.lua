AddCommand("whitelistadd", function(player, steamid)
	if PlayerData[player].adminlevel >= 3 then
		if steamid == nil then 
			print("Invalid Usage : /whitelistadd <steamid>")
			AddPlayerChat(player, "Invalid Usage : /whitelistadd <steamid>")
		else
			mariadb_query(sql, mariadb_prepare(sql, "INSERT INTO whitelist (steamid) VALUES ('?')", steamid), function(player)
				if (mariadb_get_affected_rows() >= 1) then
					print("Successfully added " .. steamid .. " to whitelist!")
				end
			end, player)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /whitelistadd without permission!")
	end
end)

AddCommand("whitelistremove", function(player, steamid)
	if PlayerData[player].adminlevel >= 3 then
		if steamid == nil then 
			print("Invalid Usage : /whitelistremove <steamid>")
			AddPlayerChat(player, "Invalid Usage : /whitelistremove <steamid>")
		else
			mariadb_query(sql, mariadb_prepare(sql, "DELETE FROM whitelist WHERE steamid = '?'", steamid), function(player)
				if (mariadb_get_affected_rows() >= 1) then
					print("Successfully removed " .. steamid .. " from whitelist!")
				end
			end, player)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /whitelistremove without permission!")
	end
end)

AddCommand("tpcoords", function(player, x, y, z)
	if PlayerData[player].adminlevel >= 3 then
		if x == nil or y == nil or z == nil then 
			print("Invalid Usage : /tpcoords <x> <y> <z>")
		else
			SetPlayerLocation(player, x, y, z)
			print("Telported " .. GetPlayerSteamId(player) .. " to " .. x .. " " .. y .. " " .. z)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /tpcoords without permission!")
	end
end)

AddCommand("tpto", function(player, player2)
	local x, y, z = GetPlayerLocation(player2)
	if player2 == nil then print("Invalid Usage : /tpto <player>") return end
	if PlayerData[player].adminlevel >= 3 then
		SetPlayerLocation(player, x, y, z)
		print(GetPlayerName(player) .. " teleported to " .. GetPlayerSteamId(player2))
	else
		print(GetPlayerSteamId(player) .. " tried using /tpto without permission!")
	end
end)

AddCommand("tptome", function(player, player2)
	local x, y, z = GetPlayerLocation(player)
	if player2 == nil then print("Invalid Usage : /tptome <player>") return end
	if PlayerData[player].adminlevel >= 3 then
		SetPlayerLocation(player2, x, y, z)
		print(GetPlayerName(player) .. " teleported " .. GetPlayerSteamId(player2) .. " to themselves!")
	else
		print(GetPlayerSteamId(player) .. " tried using /tpto without permission!")
	end
end)

AddCommand("setadmin", function(player, player2, level)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or level == nil then
			print("Invalid Usage : /setadmin <player> <level>")
		else
			PlayerData[player2].adminlevel = level
			print("Set " .. GetPlayerSteamId(player2) .. "'s admin level!")
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /setadmin without permission!")
	end
end)

AddCommand("setjob", function(player, player2, job, jobrank)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or job == nil or jobrank == nil then
			print("Invalid Usage : /setjob <player> <job> <jobrank>")
		else
			PlayerData[player].job = job
			PlayerData[player].jobrank = jobrank
			print("Set " .. GetPlayerSteamId(player2) .. "'s Job to " .. job .. " [" .. jobrank .. "]")
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /setjob without permission!")
	end
end)

AddCommand("kick", function(player, player2, reason)
	if PlayerData[player].adminlevel >= 3 then
		kickReason = reason or _('def_kick_reason')
		if player2 == nil then
			print("Invalid Usage : /kick <player> <reason>")
		else
			KickPlayer(player2, kickReason)
			print("Kicked " .. GetPlayerSteamId(player2) .. " from the server for " .. kickReason)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /kick without permission!")
	end
end)

AddCommand("ban", function(player, plySteam, reason, type, duration)
	if string.len(plySteam) < 10 then print("Invalid Usage : /ban <steamid> <reason> <type> <duration (optional)>") end
	local banDuration = duration or -1
	if PlayerData[player].adminlevel >= 3 then
		banReason = reason or _('def_ban_reason')
		if plySteam == nil or type == nil then
			print("Invalid Usage : /ban <steamid> <reason> <type> <duration (optional)>")
		else
			BanPlayer(player, plySteam, reason, type, banDuration)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /ban without permission!")
	end
end)

AddCommand("addcash", function(player, player2, amount)
	local SteamID = GetPlayerSteamId(player2)
	print(player, PlayerData[player].cash)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or amount == nil then
			print("Invalid Usage : /addcash <player> <amount>")
		else
			print(tonumber(player2), PlayerData[tonumber(player2)])
			PlayerData[tonumber(player2)].cash = PlayerData[tonumber(player2)].cash + amount
			UpdatePlayerHud(player, "cash", PlayerData[tonumber(player2)].cash)
			print(GetPlayerName(player) .. " gave " .. SteamID .. " $" .. amount)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /addcash without permission!")
	end
end)

AddCommand("removecash", function(player, player2, amount)
	local SteamID = GetPlayerSteamId(player2)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or amount == nil then
			print("Invalid Usage : /removecash <player> <amount>")
		else
			PlayerData[tonumber(player2)].cash = PlayerData[tonumber(player2)].cash - amount
			UpdatePlayerHud(player, "cash", PlayerData[tonumber(player2)].cash)
			print(GetPlayerName(player) .. " removed $" .. amount .. " from " .. SteamID)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /removecash without permission!")
	end
end)

AddCommand("addbank", function(player, player2, amount)
	local SteamID = GetPlayerSteamId(player2)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or amount == nil then
			print("Invalid Usage : /addbank <player> <amount>")
		else
			PlayerData[tonumber(player2)].bank = PlayerData[tonumber(player2)].bank + amount
			UpdatePlayerHud(player, "bank", PlayerData[tonumber(player2)].bank)
			print(GetPlayerName(player) .. " added $" .. amount .. " to " .. SteamID .. "'s bank")
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /addbank without permission!")
	end
end)

AddCommand("removebank", function(player, player2, amount)
	local SteamID = GetPlayerSteamId(player2)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or amount == nil then
			print("Invalid Usage : /removebank <player> <amount>")
		else
			PlayerData[tonumber(player2)].bank = PlayerData[tonumber(player2)].bank - amount
			UpdatePlayerHud(player, "bank", PlayerData[tonumber(player2)].bank)
			print(GetPlayerName(player) .. " removed $" .. amount .. " from " .. SteamID .. "'s bank")
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /removebank without permission!")
	end
end)

AddCommand("adddirty", function(player, player2, amount)
	local SteamID = GetPlayerSteamId(player2)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or amount == nil then
			print("Invalid Usage : /adddirty <player> <amount>")
		else
			PlayerData[tonumber(player2)].dirtymoney = PlayerData[tonumber(player2)].dirtymoney + amount
			UpdatePlayerHud(player, "dirty", PlayerData[tonumber(player2)].dirtymoney)
			print(GetPlayerName(player) .. " added $" .. amount .. " Dirty Money to " .. SteamID)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /adddirty without permission!")
	end
end)

AddCommand("removedirty", function(player, player2, amount)
	local SteamID = GetPlayerSteamId(player2)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or amount == nil then
			print("Invalid Usage : /removedirty <player> <amount>")
		else
			PlayerData[tonumber(player2)].dirtymoney = PlayerData[tonumber(player2)].dirtymoney - amount
			UpdatePlayerHud(player, "dirty", PlayerData[tonumber(player2)].dirtymoney)
			print(GetPlayerName(player) .. " removed $" .. amount .. " Dirty Money from " .. SteamID)
		end
	else
		print(GetPlayerSteamId(player) .. " tried using /removedirty without permission!")
	end
end)

AddCommand("setjob", function(player, player2, job, jobrank)
	print(player, player2, job, jobrank)
	local SteamID = GetPlayerSteamId(player2)
	local NewRank = jobrank or 0
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or job == nil then print("Invalid Usage : /setjob <player> <job> <jobrank (optional)>") return end
		PlayerData[tonumber(player2)].job = job
		PlayerData[tonumber(player2)].jobrank = NewRank
		local data = { PlayerData[tonumber(player2)].job, PlayerData[tonumber(player2)].jobrank }
		UpdatePlayerHud(player, "job", data)
		print(GetPlayerName(player) .. " set " .. SteamID .. "'s Job to " .. job .. " and Job Rank to " .. NewRank)
	else
		print(GetPlayerSteamId(player) .. " tried using /setjob without permission!")
	end
end)

AddCommand("spawnveh", function(player, veh)
	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)
	if PlayerData[player].adminlevel >= 3 then
		if veh == nil then print("Invalid Usage : /spawnveh <vehicleID>") return end
		local veh = CreateVehicle(veh, x, y, z, h)
		SetPlayerInVehicle(player, veh, 1)
		print(GetPlayerName(player) .. " spawned a vehicle!")
	else
		print(GetPlayerSteamId(player) .. " tried using /spawnveh without permission!")
	end
end)

AddCommand("delveh", function(player)
	if PlayerData[player].adminlevel >= 3 then
		if IsPlayerInVehicle(player) == true then
			DestroyVehicle(GetPlayerVehicle(player))
		else
			local rVeh, rDist = GetNearestVehicle(player)
			if rVeh ~= nil and rDist <= 500 then
				DestroyVehicle(rVeh)
			end
		end
		print(GetPlayerName(player) .. " deleted a vehicle!")
	else
		print(GetPlayerSteamId(player) .. " tried using /spawnveh without permission!")
	end
end)

function GetNearestVehicle(player)
	local vehicles = GetStreamedVehiclesForPlayer(player)
	local found = 0
	local nearest_dist = 1000
	local x, y, z = GetPlayerLocation(player)

	for _,v in pairs(vehicles) do
		local x2, y2, z2 = GetVehicleLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < nearest_dist then
			nearest_dist = dist
			found = v
		end
	end
	return found, nearest_dist
end

AddCommand("giveweapon", function(player, player2, weapon, slot)
	if PlayerData[player].adminlevel >= 3 then
		if player2 == nil or weapon == nil or slot == nil then print("Invalid Usage : /giveweapon <player> <weaponID> <slot>") return end
		SetPlayerWeapon(player2, weapon, 100, true, slot, true)
		print(GetPlayerName(player) .. " gave a weapon to " .. GetPlayerSteamId(player2))
	else
		print(GetPlayerSteamId(player) .. " tried using /giveweapon without permission!")
	end
end)

AddCommand("help", function(player)
	if PlayerData[player].adminlevel >= 3 then
		AddPlayerChat(player, "Discord: discordlink \n Wiki: wikilink")
	else
		if ENABLE_HELP_COMMAND == true then
			AddPlayerChat(player, "Help: " .. HELP_COMMAND_SITE)
		end
	end
end)

AddCommand("ooc", function(player, ...)
	if ENABLE_OOC_CHAT == true then
		local msg = table.concat({...}, " ")
		AddPlayerChatAll('<span color="#a6a6a6" style="italic">' .. "[OOC] " .. GetPlayerName(player) .. ": " .. msg .. '</>')
	end
end)

AddCommand("me", function(player, ...)
	if ENABLE_ME_CHAT == true then
		local msg = table.concat({...}, " ")
		local currentMe = GetPlayerPropertyValue(player, "meText")
		if currentMe ~= nil then
			DestroyText3D(currentMe)
			SetPlayerPropertyValue(player, "meTextDelay", nil)
		end
		local x, y, z = GetPlayerLocation(player)
		local meText = CreateText3D("~" .. msg .. "~", 20, x, y, z, 0, 0, 0)
		SetText3DAttached(meText, ATTACH_PLAYER, player, 0, 0, 200)
		SetPlayerPropertyValue(player, "meText", meText)
		SetPlayerPropertyValue(player, "meTextDelay", Delay(4000, function(meText)
			DestroyText3D(meText)
			SetPlayerPropertyValue(player, "meTextDelay", nil)
		end, meText))
	end
end)

AddCommand("do", function(player, ...)
	if ENABLE_DO_CHAT == true then
		local msg = table.concat({...}, " ")
		local currentDo = GetPlayerPropertyValue(player, "doText")
		if currentDo ~= nil then
			DestroyText3D(currentDo)
			SetPlayerPropertyValue(player, "doTextDelay", nil)
		end
		local x, y, z = GetPlayerLocation(player)
		local doText = CreateText3D("~" .. msg .. "~", 20, x, y, z, 0, 0, 0)
		SetText3DAttached(doText, ATTACH_PLAYER, player, 0, 0, 200)
		SetPlayerPropertyValue(player, "doText", doText)
		SetPlayerPropertyValue(player, "doTextDelay", Delay(4000, function(doText)
			DestroyText3D(doText)
			SetPlayerPropertyValue(player, "doTextDelay", nil)
		end, doText))
	end
end)

AddEvent("OnPlayerChat", function(player, text)
	local x, y = GetPlayerLocation(player)
	if ENABLE_LOCAL_CHAT == true then
		AddPlayerChatRange(x, y, "[Local] " .. GetPlayerName(player) .. ": " .. LOCAL_CHAT_RANGE, text)
	end
end)
