local currentView = 2 -- 1 = First Person, 2 = 3rd Person, 3 = 3rd Person Extended

AddEvent("OnPackageStart", function()
    CreateTimer(function()
        CallRemoteEvent("UpdatePlayerData")
    end, 300000)
end)

AddEvent("OnPlayerTalking", function(player)
    SetPlayerLipMovement(player)
end)

function SyncTime(time)
    SetTime(time)
end
AddRemoteEvent("SyncTime", SyncTime)

function SyncWeather(weather)
    SetWeather(weather)
end
AddRemoteEvent("SyncWeather", SyncWeather)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
    TogglePlayerTag(player, "name", SHOW_NAME_TAG)
    TogglePlayerTag(player, "health", SHOW_HEALTH_TAG)
    TogglePlayerTag(player, "armor", SHOW_ARMOR_TAG)
    TogglePlayerTag(player, "voice", SHOW_VOICE_TAG)
end)

function ToggleHud(HealthHUD, WeaponHUD)
    ShowHealthHUD(HealthHUD)
    ShowWeaponHUD(WeaponHUD)
end
AddRemoteEvent("ToggleHud", ToggleHud)

AddEvent("OnPackageStart", function()
    CreateTimer(function()
        local x, y, z = GetPlayerLocation()
        tH = GetTerrainHeight(x, y, z + 99999.9)
        if z < 0 and tH - 400 > z and not IsPlayerInVehicle() then
            CallRemoteEvent("UndergoundTP", x, y, z, tH)
        end
    end, 2000)
end)

AddEvent("OnKeyPress", function(key)
    if key == "V" and ENABLE_CHANGE_VIEW == true then
        if currentView == 1 then
            currentView = 2
			EnableFirstPersonCamera(false)
            SetNearClipPlane(0)
            SetCameraViewDistance(375)
        elseif currentView == 2 then
            currentView = 3
            SetCameraViewDistance(450)
        elseif currentView == 3 then
            currentView = 1
			EnableFirstPersonCamera(true)
			SetNearClipPlane(25)
        end
    end
end)

