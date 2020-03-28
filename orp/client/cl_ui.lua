AddEvent("OnPackageStart", function()
    INFO_UI = CreateWebUI(0, 0, 0, 0, 6, 30)
    LoadWebFile(INFO_UI, "http://asset/" .. GetPackageName() .. "/ui/index.html")
    SetWebAlignment(INFO_UI, 1.0, 1.0)
    SetWebAnchors(INFO_UI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(INFO_UI, WEB_HITINVISIBLE)
end)

AddEvent("OnPackageStop", function()
	DestroyWebUI(INFO_UI)
end)

function ToggleInfoUI(bool)
    if bool then

    else

    end 
end
AddRemoteEvent("ORP:ToggleInfoUI", ToggleInfoUI)
AddFunctionExport("ToggleInfoUI", ToggleInfoUI)

function UpdateUIJS(type, data)
    if type == "cash" then
        cashData = string.format("%.2f", data)
        ExecuteWebJS(INFO_UI, "UpdateCash('"..cashData.."')")
    elseif type == "bank" then
        bankData = string.format("%.2f", data)
        ExecuteWebJS(INFO_UI, "UpdateBank('"..data.."')")
    elseif type == "dirty" then
        dirtyData = string.format("%.2f", data)
        ExecuteWebJS(INFO_UI, "UpdateDirtyMoney('"..dirtyData.."')")
	elseif type == "job" then
        ExecuteWebJS(INFO_UI, "UpdateJob('"..data[1].."', '"..data[2].."')")
	end
end
AddRemoteEvent("ORP:UpdateUIJS", UpdateUIJS)

AddEvent("OnWebLoadComplete", function(web)
    CallRemoteEvent("ORP:FetchUIInfo")
end)

AddEvent("OnKeyPress", function(key)
    if key == "Home" then
        CallRemoteEvent("ORP:GetPlayerInfo")        
        SetInputMode(INPUT_GAMEANDUI)
        ShowMouseCursor(true)
    end
end)

AddEvent("OnKeyRelease", function(key)
    if key == "Home" then
        ExecuteWebJS(INFO_UI, "HidePlayerList()")       
        SetInputMode(INPUT_GAME)
        ShowMouseCursor(false)
    end
end)

function SendPlayerInfoJS(id, name, steamid, ping)
    ExecuteWebJS(INFO_UI, "ShowPlayerList()")
    ExecuteWebJS(INFO_UI, "AppendPlayerInfo('"..id.."', '"..name.."', '"..steamid.."', '"..ping.."')")
end
AddRemoteEvent("ORP:SendPlayerInfoJS", SendPlayerInfoJS)