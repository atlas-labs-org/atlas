--[[ Created by MochaTheDev and WakeTheTyrant
     ____.                                                    _____       .___      .__        
    |    |____    _____ _____ _______  ____  __ __  ______   /  _  \    __| _/_____ |__| ____  
    |    \__  \  /     \\__  \\_  __ \/ ___\|  |  \/  ___/  /  /_\  \  / __ |/     \|  |/    \ 
/\__|    |/ __ \|  Y Y  \/ __ \|  | \|  \___|  |  /\___ \  /    |    \/ /_/ |  Y Y  \  |   |  \
\________(____  /__|_|  (____  /__|   \___  >____//____  > \____|__  /\____ |__|_|  /__|___|  /
              \/      \/     \/           \/           \/          \/      \/     \/        \/ 
VERSION~~ (v2.0.0)
--==============================================================================================
*NOTE: This is the core of the system. Do not edit anything below unless you are absolutely
sure of what you are doing, and/or have been authorized by the user of the system to do so.
Many of the below functions are extremely sensitive and the slightest incorrect update to the
processes may irreperably damage the entire system and a full re-load and reconfiguration may be
required.
]]

-- Core Dependencies
local replicatedStorage = game:GetService("ReplicatedStorage")
local playerService = game:GetService("Players")
local repstgpath = game.ReplicatedStorage.jamarcus_RepStg
local TextChatService = game:GetService("TextChatService")
local settingsModule = require(repstgpath.Settings)
local dependencymodule = require(repstgpath.coredependency)
local pluginsFolder = repstgpath.Plugins
local serverBannedUsers = {}
local DataStore = game:GetService("DataStoreService"):GetDataStore(settingsModule.datastore)
local MarketplaceService = game:GetService("MarketplaceService")
local remotes = repstgpath:FindFirstChild("Remotes", true)

local unstable = true

if repstgpath:FindFirstChild("License") then
	license = require(repstgpath:FindFirstChild("License"))-- REMOVAL WILL RESULT IN FULL SYSTEM LOCKOUT
end

local commandPrefix = settingsModule.prefix
local canJoin = true
local whitelistEnabled = false
local whitelist = {}

local admins = {}
local groupadmins = {}
local globalgroupadmins = {}

local plugins = {}

local remotes_necessary = {}

local assetId = 0

if unstable then
	assetId = 17166276503
	local asset = MarketplaceService:GetProductInfo(assetId)
	currentVersion = asset.Description:match("VERSION: (%d+\.%d+\.%d+)")
elseif not unstable then
	assetId = 17166069350
	local asset = MarketplaceService:GetProductInfo(assetId)
	currentVersion = asset.Description:match("VERSION: (%d+\.%d+\.%d+)")
end

-- Command Functions

local function closestPlayerName(incompleteString)
	local closestName = nil
	local closestDistance = math.huge

	for _, player in ipairs(game.Players:GetPlayers()) do
		local playerName = player.Name:lower()

		if playerName:sub(1, #incompleteString) == incompleteString:lower() then
			return player.Name
		end
	end

	return closestName
end

local function closestItemName(incompleteString)
	local closestItem = nil
	local closestDistance = math.huge

	for _, item in ipairs(game.ServerStorage:GetChildren()) do
		local playerName = item.Name:lower()

		if playerName:sub(1, #incompleteString) == incompleteString:lower() then
			return item.Name
		end
	end

	return closestItem
end

local function closestNameInList(incompleteString, tab)
	local closestItem = nil
	local closestDistance = math.huge

	for _, item in ipairs(tab) do
		local playerName = item.Name:lower()

		if playerName:sub(1, #incompleteString) == incompleteString:lower() then
			return item.Name
		end
	end

	return closestItem
end

function notify(plr, msg, sendplayer)
	remotes:FindFirstChild("Notify", true):FireClient(plr, msg, sendplayer)
end

function notifyAll(msg, sendplayer)
	remotes:FindFirstChild("Notify", true):FireAllClients(msg, sendplayer)
end

function notifyUi(plr, msg, isinfo, title, bodytext)
	if isinfo and title and bodytext then
		remotes:FindFirstChild("makeNotificationUI"):FireClient(plr, msg, isinfo, title, bodytext)
	else
		remotes:FindFirstChild("makeNotificationUI"):FireClient(plr, msg, false, "")
	end
end

function notifyUiAll(msg, isinfo, title, bodytext)
	if isinfo and title then
		for _, v in playerService:GetPlayers() do
			remotes:FindFirstChild("makeNotificationUI"):FireClient(v, msg, isinfo, title, bodytext)
		end
	else
		for _, v in playerService:GetPlayers() do
			remotes:FindFirstChild("makeNotificationUI"):FireClient(v, msg, false, "")
		end
	end
end

function reload_system(components) -- DO NOT USE
	if components ~= "components" then
		warn([["
		==========================================
		WARNING: Admin system rebooting...
		==========================================
		"]])
		local insertServ = game:GetService("InsertService")

		game:GetService("ServerScriptService"):FindFirstChild("jamarcus_SrvScrptSrv", true).Name = "jamarcus_SrvScrptSrv_dep"
		replicatedStorage:FindFirstChild("Settings", true).Parent = game.Workspace
		local newsetts = require(game.Workspace:FindFirstChild("Settings", true))
		replicatedStorage:FindFirstChild("jamarcus_RepStg", true):Destroy()
		game:GetService("StarterGui"):FindFirstChild("jamarcus_StarterGui", true):Destroy()
		
		for _, v in playerService:GetPlayers() do
			v.PlayerGui:FindFirstChild("jamarcus_StarterGui"):Destroy()
		end
		
		local newSys = insertServ:LoadAsset(assetId)
		newSys.Parent = game.Workspace

		newSys:FindFirstChild("jamarcus_RepStg", true).Parent = replicatedStorage
		newSys:FindFirstChild("jamarcus_SrvScrptSrv", true).Parent = game:GetService("ServerScriptService")
		newSys:FindFirstChild("jamarcus_StarterGui", true).Parent = game:GetService("StarterGui")
		
		for _, v in playerService:GetPlayers() do
			game.StarterGui.jamarcus_StarterGui:Clone().Parent = v.PlayerGui
		end
		
		replicatedStorage:FindFirstChild("jamarcus_RepStg", true).Settings:Destroy()
		game.Workspace:FindFirstChild("Settings", true).Parent = replicatedStorage:FindFirstChild("jamarcus_RepStg", true)
		
		newSys:FindFirstChild("READ_ME", true):Destroy()
		newSys:FindFirstChild("AdminPart", true):Destroy()

		warn("Update completed. Rebooting...")
		
		return "done"
	end
end



function isInList(list, value)
	for i, v in list do
		if v == value then
			return true
		else
			return false
		end
	end
end

function isInGroupAdmin(plrname)
	local found = false
	
	for i, v in pairs(groupadmins) do
		local split = string.split(v, ":")
		local groupid = tonumber(split[2])
		local grouprank = tonumber(split[3])
		
		if playerService[plrname] then
			local plr = playerService[plrname]
			
			if plr:IsInGroup(groupid) then
				if plr:GetRankInGroup(groupid) == grouprank then
					found = true
				end
			end
		else
			return false
		end
	end
	
	if settingsModule.global_group_id_enabled then
		local globalid = tonumber(settingsModule.global_group_id)
		for i, v in pairs(globalgroupadmins) do
			local split = string.split(v, ":")
			local rank = tonumber(split[2])
			
			if rank then
				local player = playerService[plrname]
				
				if player then
					if player:IsInGroup(globalid) then
						if player:GetRankInGroup(globalid) == rank then
							found = true
						end
					end
				else
					return false
				end
			end
		end
	end
	
	if found == true then
		return true
	else
		return false
	end
end

function isOverride(plrname)
	
	if playerService:FindFirstChild(plrname) then
		
	else
		return false
	end
	
	if table.find(settingsModule.Override, plrname) then
		return true
	elseif table.find(settingsModule.Override, playerService:GetUserIdFromNameAsync(plrname)) then
		return true
	elseif settingsModule.debug == true then
		return true
	else
		return false
	end
end

function isAdmin(user)
	if playerService:FindFirstChild(user) then

	else
		return false
	end
	
	if table.find(admins, user) then
		return true
	elseif table.find(admins, tostring(playerService:GetUserIdFromNameAsync(user))) then
		return true
	elseif settingsModule.debug == true then
		return true
	elseif isOverride(user) then
		return true
	elseif isOverride(playerService:GetUserIdFromNameAsync(user)) then
		return true
	elseif isInGroupAdmin(user) then
		return true
	else
		print("NOT ADMIN")
		return false
	end
end

function tryKick(perp, reason) -- Type of perp: String
	perp = closestPlayerName(perp)
	
	if playerService:FindFirstChild(perp) then
		playerService[perp]:Kick(reason)
	end
end

function tryServerBan(perp) -- Type of perp: String
	perp = closestPlayerName(perp)
	
	if playerService:GetUserIdFromNameAsync(perp) then
		table.insert(serverBannedUsers, playerService:GetUserIdFromNameAsync(perp))
		print("done")
		tryKick(perp)
	end
end

function tryChatMute(perp) -- Type of perp: String
	perp = closestPlayerName(perp)
	
	if TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral"):FindFirstChild(perp) then
		game.TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral"):FindFirstChild(perp).CanSend = false
	end
end

function tryChatUnmute(perp)
	perp = closestPlayerName(perp)
	
	if TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral"):FindFirstChild(perp) then
		game.TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral"):FindFirstChild(perp).CanSend = true
	end
end

function resetPlayer(perp) -- Type of perp: String)
	local pos = 0

	if playerService:FindFirstChild(perp) then
		pos = playerService[perp].Character.HumanoidRootPart.Position
		wait(playerService[perp]:LoadCharacter())
		playerService[perp].Character.HumanoidRootPart.Position = pos
	elseif playerService:FindFirstChild(closestPlayerName(perp)) ~= nil then
		perp = closestPlayerName(perp)
		pos = playerService[perp].Character.HumanoidRootPart.Position
		wait(playerService[perp]:LoadCharacter())
		playerService[perp].Character.HumanoidRootPart.Position = pos	
	else
		print("no player")
	end
end

function announce(text)
	local text1 = text
	
	if text1 == nil or text1 == "" then
		print("no text")
	else
		remotes.Announcement:FireAllClients(text1)
	end
end

function shutdown(reason)
	remotes.Announcement:FireAllClients("Server is shutting down!")
	wait(2)
	canJoin = false
	if reason then
		for _, v in playerService:GetPlayers() do
			v:Kick("SERVER SHUTDOWN: "..reason)
		end
	else
		for _, v in playerService:GetPlayers() do
			v:Kick("Server shutdown!")
		end
	end
end

function giveTool(playertogive, tool)
	
	playertogive = closestPlayerName(playertogive)
	tool = closestItemName(tool)
	
	local ServerStorage = game:GetService("ServerStorage")
	
	local clone = ServerStorage:FindFirstChild(tool):Clone()
	
	clone.Parent = playerService[playertogive].Backpack
end

function removeTool(player, tool)
	player = closestPlayerName(player)
	tool = closestNameInList(tool, playerService[player].Backpack:GetChildren())
	
	playerService[player]:FindFirstChild("Backpack", true):FindFirstChild(tool, true):Remove()
end

function addWhitelist(plr)
	if playerService:FindFirstChild(closestPlayerName(plr), true) then
		plr = closestPlayerName(plr)
	end
	
	if not table.find(whitelist, plr) and not table.find(whitelist, playerService:GetUserIdFromNameAsync(plr)) then
		table.insert(whitelist, plr)
	end
end

function bringPlayer(plr, playertobring)
	playertobring = closestPlayerName(playertobring)
	
	local offset = Vector3.new(0, 0, 5)  -- Adjust offset as needed
	local player1 = plr.Character
	
	local player2 = playerService[playertobring].Character

	if player1 and player2 then
		local root1 = player1:FindFirstChild("Humanoid")
		local root2 = player2:FindFirstChild("Humanoid")

		if root1 and root2 then
			player2.HumanoidRootPart.Position = player1.HumanoidRootPart.Position + Vector3.new(0, 0, 5)
		end
	end
end

function addAdmin(plr, user)
	user = closestPlayerName(user)
	
	if table.find(admins, user) or table.find(admins, playerService:GetUserIdFromNameAsync(user)) or table.find(admins, closestPlayerName(user)) then
		notifyUi(plr, "User is already an admin!")
	else
		table.insert(admins, user)
		notifyUi(plr, "User "..user.." has been given server admin!")
	end
end

function unAdmin(plr, user)
	user = closestPlayerName(user)
	
	if table.find(admins, user) or table.find(admins, playerService:GetUserIdFromNameAsync(user)) then
		for i, v in admins do
			if v == user or playerService:GetUserIdFromNameAsync(user) == v then
				table.remove(admins, i)
				notifyUi(plr, "User "..user.." has been removed from the admin list for this server.")
			end
		end
	else
		notifyUi(plr, "User "..user.." not found. Check name and try again.")
	end
end

function open_cmds(plr)
	remotes.cmds:FireClient(plr)
end

-- Function to enable forcefield for a player
local function enableForcefield(player)
	player = playerService[closestPlayerName(player)]
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			-- Check if the player already has a forcefield
			local forcefield = character:FindFirstChildOfClass("ForceField")
			if not forcefield then
				-- Add a forcefield if it doesn't exist
				local newForcefield = Instance.new("ForceField")
				newForcefield.Parent = character
				return player.Name .. " has been given a forcefield."
			else
				return player.Name .. " already has a forcefield."
			end
		else
			return "Player " .. player.Name .. " does not have a humanoid."
		end
	end
end

-- Function to disable forcefield for a player
local function disableForcefield(player)
	player = playerService[closestPlayerName(player)]
	local character = player.Character
	if character then
		local forcefield = character:FindFirstChildOfClass("ForceField")
		if forcefield then
			-- Remove the forcefield if it exists
			forcefield:Destroy()
			return player.Name .. "'s forcefield has been removed."
		else
			return player.Name .. " does not have a forcefield."
		end
	else
		return "Player " .. player.Name .. " is not in the game."
	end
end

function mUi(msg)
	local remote = remotes.serverM
	
	if msg then
		remote:FireAllClients(msg)
	else
		
	end
end

function onPlayerChat(plr, msg)
		local split = msg:split(" ")
		split[1] = split[1]:lower()
		
		if string.sub(split[1], 1, 1) == commandPrefix then
			if isAdmin(plr.Name) == true then
				if split[1] == commandPrefix.."kick" then
					if split[2] then
						if isOverride(split[2]) == false then
							local reason1 = ""
							for i, v in pairs(split) do
								if i > 2 then
									reason1 = reason1..v.." "
								end
							end
							tryKick(split[2], reason1)
							notifyUi(plr, "User "..split[2].." kicked!")
						end
					end
				elseif split[1] == commandPrefix.."serverban" or split[1] == commandPrefix.."sb" then
					if split[2] then
						if isOverride(split[2]) == false then
							tryServerBan(split[2])
							notifyUi(plr, "User "..split[2].." serverbanned!")
						end
					end
				elseif split[1] == commandPrefix.."mute" then
					if split[2] then
						if isOverride(split[2]) == false then
							tryChatMute(split[2])
							notifyUi(plr, "User "..split[2].." muted!")
						end
					end
				elseif split[1] == commandPrefix.."unmute" then
					if split[2] then
						if isOverride(split[2]) == false then
							tryChatUnmute(split[2])
							notifyUi(plr, "User "..split[2].." unmuted!")
						end
					end
				elseif split[1] == commandPrefix.."reset" or split[1] == commandPrefix.."re" then
					if split[2] then
						if split[2] ~= "me" and split[2] ~= "all" then
							resetPlayer(split[2])
						elseif split[2] == "all" then
							for _, v in playerService:GetPlayers() do
								resetPlayer(v.Name)
							end
						elseif split[2] == "me" then
							resetPlayer(plr.Name)
						end
					else
						resetPlayer(plr.Name)
					end
				elseif split[1] == commandPrefix.."bring" then
					if split[2] then
						if isOverride(split[2]) == false then
							bringPlayer(plr, split[2])
						end
					end
				elseif split[1] == commandPrefix.."announce" or split[1] == commandPrefix.."a" or split[1] == commandPrefix.."sm" then
					if split[2] then
						local announcetext = ""
						for i, v in pairs(split) do
							if i >= 2 then
								announcetext = announcetext..v.." "
							end
						end
						announcetext:sub(1,announcetext:len()-1)
						announce(announcetext)
					end
				elseif split[1] == commandPrefix.."give" then
					if split[2] == "me" then
						giveTool(plr.Name, split[3])
						notifyUi(plr, "User "..closestPlayerName(split[2]).." given "..closestItemName(split[3]))
					elseif split[2] == "all" then
						for _, v in playerService:GetPlayers() do
							giveTool(v.Name, split[3])
							notifyUi(plr, #playerService:GetPlayers().." given "..closestItemName(split[3]))
						end
					else
						giveTool(split[2], split[3])
						notifyUi(plr, "User "..closestPlayerName(split[2]).." given "..closestItemName(split[3]))
					end
					
				elseif split[1] == commandPrefix.."remove" then
					if split[2] == "me" then
						removeTool(plr.Name, closestItemName(split[3]))
					elseif split[2] == "all" then
						for _, v in playerService:GetPlayers() do
							removeTool(v.Name, closestItemName(split[3]))
						end
					else
						removeTool(closestPlayerName(split[2]), closestItemName(split[3]))
					end
				elseif split[1] == commandPrefix.."shutdown" then
					if split[2] then
						shutdown(split[2])
					else
						shutdown()
					end
				elseif split[1] == commandPrefix.."whitelist" then
					if split[2] then
						addWhitelist(split[2])
						notifyUi(plr, "User "..split[2].." whitelisted!")
					else
						table.insert(whitelist, plr.Name)
						whitelistEnabled = true
						wait(table.find(whitelist, plr.Name))
						for _, v in playerService:GetPlayers() do
							if table.find(whitelist, v.Name) then

							elseif table.find(whitelist, v.UserId) then

							else
								v:Kick("Server has been locked!")
							end
						end
						notifyAll("Whitelist enabled! Kicking non-permitted players...", "System")
					end
				elseif split[1] == commandPrefix.."unwhitelist" then
					if split[2] then
						for i, v in pairs(whitelist) do
							if v == split[2] then
								table.remove(whitelist, i)
								playerService[v]:Kick("You have been removed from the whitelist!")
							end
						end
						notifyUi(plr, "User "..split[2].." unwhitelisted!")
					else
						whitelistEnabled = false
						notifyUi(plr, "Whitelist disabled!")
					end
				elseif split[1] == commandPrefix.."unban" then
					if split[2] then
						if table.find(serverBannedUsers, split[2]) then
							for i, v in pairs(serverBannedUsers) do
								if v == split[2] then
									table.remove(serverBannedUsers, i)
								elseif playerService:GetUserIdFromNameAsync(v) then
									table.remove(serverBannedUsers, i)
								end
							end
						end

						if DataStore:GetAsync(playerService:GetUserIdFromNameAsync(split[2])) then
							if DataStore:GetAsync(playerService:GetUserIdFromNameAsync(split[2])) == true then
								DataStore:SetAsync(playerService:GetUserIdFromNameAsync(split[2]), false)
							end
						end
						notifyUi(plr, "User "..split[2].." unbanned")
					end
				elseif split[1] == commandPrefix.."ban" then
					if split[2] then
						split[2] = closestPlayerName(split[2])
						if isOverride(split[2]) == false then
							if DataStore:GetAsync(playerService:GetUserIdFromNameAsync(split[2])) then

							else
								DataStore:SetAsync(playerService:GetUserIdFromNameAsync(split[2]), true)
								if split[3] then
									playerService[split[2]]:Kick("You've been banned! Reason: "..split[3])
								else
									playerService[split[2]]:Kick("You've been banned!")
								end
							end
							notify(plr, "User "..split[2].." banned!", "System")
						end
					end
				elseif split[1] == commandPrefix.."n" or split[1] == commandPrefix.."h" then
					if split[2] then
						if split[1] == commandPrefix.."h" or split[1] == commandPrefix.."n" then
							local msgtxt = ""
							for i, v in split do
								if i >= 2 then
									msgtxt = msgtxt..v.." "
								end
							end

							notifyAll(msgtxt, plr.Name)
						end
					end
				elseif split[1] == commandPrefix.."admin" then
					if split[2] then
						addAdmin(plr, split[2])
					end
				elseif split[1] == commandPrefix.."unadmin" then
					if isOverride(plr.Name) == true then
						if split[2] then
							unAdmin(plr, split[2])
						end
					end
				elseif table.find(plugins, split[1]) then
					local plugin_registry = require(pluginsFolder[split[1]])
					
					if plugin_registry.override_only == true then
						if isOverride(plr.Name) == true then
							local func = plugin_registry.commandFunction
							if split[2] then
								if plugin_registry.closest_name == true then
									split[2] = closestPlayerName(split[2])
								end
								if split[3] then
									func(split[2], split[3])
								else
									func(split[2])
								end
							else
								func()
							end
						end
					else
						local func = plugin_registry.commandFunction
						if split[2] then
							if plugin_registry.closest_name == true then
								split[2] = closestPlayerName(split[2])
							end
							if split[3] then
								func(split[2], split[3])
							else
								func(split[2])
							end
						else
							func()
						end
					end

					if plugin_registry.notification ~= false then
						notifyUi(plr, plugin_registry.notification)
					end
				elseif split[1] == commandPrefix.."reboot" then
					if isOverride(plr.Name) == true then
						reload_system()
					end
				elseif split[1] == commandPrefix.."sit" then
					if settingsModule.fun_commands == true then
						if split[2] then
							split[2] = closestPlayerName(split[2])
							local sitplr = playerService[split[2]]

							sitplr.Character.Humanoid.Sit = true
						end
					end
				elseif split[1] == commandPrefix.."jump" then
					if  settingsModule.fun_commands == true then
						if split[2] then
							split[2] = closestPlayerName(split[2])
							local jumpplr = playerService[split[2]]

							jumpplr.Character.Humanoid.Jump = true
						end
					end
				elseif split[1] == commandPrefix.."kill" then
					if isOverride(split[2]) == false then
						if split[2] then
							split[2] = closestPlayerName(split[2])
							local killplr = playerService[split[2]]

							killplr.Character:FindFirstChild("Humanoid").Health = 0
						end
					end
				elseif split[1] == commandPrefix.."cmds" or split[1] == commandPrefix.."commands" then
					open_cmds(plr)
				elseif split[1] == commandPrefix.."ff" or split[1] == commandPrefix.."forcefield" then
					if split[2] then
						enableForcefield(split[2])
					else
						enableForcefield(plr.Name)
					end
				elseif split[1] == commandPrefix.."unff" or split[1] == commandPrefix.."unforcefield" then
					if split[2] then
						disableForcefield(split[2])
					else
						disableForcefield(plr.Name)
					end
				elseif split[1] == commandPrefix.."admins" or split[1] == commandPrefix.."adminlist" then
					remotes.admins:FireClient(plr)
				elseif split[1] == commandPrefix.."notify" or split[1] == commandPrefix.."notif" then
					if split[2] then
						if split[2] ~= "all" then
							if split[3] then
								local fmsg = ""
								for i, v in split do
									if i > 2 then
										fmsg = fmsg..v.." "
									end
								end
								notifyUi(playerService[closestPlayerName(split[2])], plr.Name..": "..fmsg)
							end
						elseif split[2] == "all" then
							if split[3] then
								local fmsg = ""
								for i, v in split do
									if i > 2 then
										fmsg = fmsg..v.." "
									end
								end
								notifyUiAll(plr.Name..": "..fmsg)
							end
						end
					end
				--elseif split[1] == commandPrefix.."m" then
				--	if split[2] then
				--		mUi(split[2])
				--	end
				end
			end
		end
end

function onPlayerAdded(plr)
	if isAdmin(plr.Name) then
		local posttxt = [["<b>UPDATE LOG</b>
		
		<b>Update log contents: </b>"]]..dependencymodule.update_log..[["
		
		<b>Current Version: </b>"]]..dependencymodule.version
		
		posttxt = string.gsub(posttxt, '"', "")
		if not unstable then
			notifyUi(plr, "Jamarcus Admin System\nVersion ["..dependencymodule.version.."]\n"..commandPrefix.."cmds for commands list\nClick for update log", true, "Update Log", posttxt)
		elseif unstable then
			notifyUi(plr, "Jamarcus Admin System\nUNSTABLE Version ["..dependencymodule.version.."]\n"..commandPrefix.."cmds for commands list\nClick for update log", true, "Update Log", posttxt)
		end	
	end
	if table.find(serverBannedUsers, tostring(plr.UserId)) then
		plr:Kick("Server Banned!")
	elseif table.find(serverBannedUsers, plr.Name) then
		plr:Kick("Server Banned!")
	end
	if canJoin == false then
		plr:Kick("Server has been shutdown!")
	end
	if DataStore:GetAsync(plr.UserId) == true then
		plr:Kick("You're banned!")
	end
	if whitelistEnabled == true then
		if table.find(whitelist, plr.Name) then
			print("Player is whitelisted!")
		elseif table.find(whitelist, playerService:GetUserIdFromNameAsync(plr.Name)) then
			print("Player is whitelisted!")
		else
			plr:Kick("Server whitelist is enabled! You are not permitted to join.")
		end
	end

	plr.Chatted:Connect(function(msg)
		onPlayerChat(plr, msg)
	end)
end

function initComponents()
	warn("Checking for missing components...")
	if repstgpath and repstgpath:FindFirstChild("Remotes") and repstgpath:FindFirstChild("Settings") and repstgpath:FindFirstChild("coredependency") and game:GetService("ServerScriptService"):FindFirstChild("jamarcus_CORE", true) and repstgpath:FindFirstChild("UI_Dep")  and repstgpath:FindFirstChild("UI_Dep"):FindFirstChild("Info_Notif") and repstgpath:FindFirstChild("UI_Dep"):FindFirstChild("Notif") and repstgpath:FindFirstChild("License") and repstgpath:FindFirstChild("AdminCommands2") then
		initialize()
	else
		if settingsModule.component_verification == true then
			if not unstable then
				reload_system()
			end
			error("Components missing! System restarting...")
		else
			error("Components missing! Please enable component verification in settings to fix.")
		end
	end
end

function initialize()
	warn("Gathering player list...")
	for i, v in game.Players:GetPlayers() do
		onPlayerAdded(v)
	end

	local start = os.time()
	warn("JamarcusAdmin is initializing...")
	print("JamarcusAdmin version: "..dependencymodule.version)
	print("JamarcusAdmin last update: "..dependencymodule.last_update)
	print("JamarcusAdmin update log: "..dependencymodule.update_log)

	warn("Loading dependencies...")
	wait(repstgpath:FindFirstChild("Settings", true))

	print("Dependencies loaded!")

	warn("System core intializing...")
	if script.Name == "jamarcus_SrvScrptSrv_dep" then
		script:Destroy()
	end
	wait(game:GetService("ServerScriptService"):FindFirstChild("jamarcus_SrvScrptSrv", true))
	print("System core loaded!")

	if settingsModule.datastore == "default_datastore" then
		warn("WARNING: You are using the default DataStore! Please update asap for security.")
	else
		print("Datastore intialized")
	end

	warn("Loading whitelist...")
	for _, v in settingsModule.whitelist do
		table.insert(whitelist, v)
	end

	warn("Loading misc settings...")
	for _, v in settingsModule.banned_users do
		table.insert(serverBannedUsers, v)
	end

	warn("Importing admins...")
	for _, v in settingsModule.Admins do
		local split = string.split(v, ":")
		
		if split[1]:lower() == "group" then
			table.insert(groupadmins, v)
		elseif split[1]:lower() == "globalgroup" then
			table.insert(globalgroupadmins, v)
		else
			table.insert(admins, v)
		end
	end
	if #admins == 0 and #groupadmins == 0 and #globalgroupadmins == 0 then
		warn("No admins to import~!")
	else
		print("Group admins... "..#groupadmins)
		print("Global group admins... "..#globalgroupadmins)
	end

	warn("Pulling remotes...")
	if game.ReplicatedStorage.jamarcus_RepStg.Remotes then
		remotes = game.ReplicatedStorage.jamarcus_RepStg.Remotes
		if currentVersion == "2.0.0" then
			if #remotes:GetChildren() == 6 then
				print("Good remote gather")
			end
		else
			print("Remote status unknown")
		end
	end

	warn("Scanning for plugins... (This may take a moment...)")
	if pluginsFolder:GetChildren() and settingsModule.plugins_enabled == true then
		for i, v in pairs(pluginsFolder:GetChildren()) do
			if v:IsA("ModuleScript") and v.Name ~= "plugin_example" then
				local plugin_info = require(v)
				local cmdname = plugin_info.command

				table.insert(plugins, commandPrefix..cmdname)

				v.Name = commandPrefix..cmdname
			end
		end

		local plugin_total = 0
		for i, v in plugins do
			plugin_total = plugin_total + 1
		end
		if plugin_total == 0 then
			print("No plugins available.")
		elseif plugin_total > 0 then
			print("Done ~ "..plugin_total.." plugin(s) loaded!")
		end
	else
		if not pluginsFolder:FindFirstChild("plugin_example") then
			print("Plugins disabled! Available plugins: "..#pluginsFolder:GetChildren())
		else
			print("Plugins disabled! Available plugins: "..#pluginsFolder:GetChildren()-1)
		end
	end

	if game:GetService("ServerScriptService"):FindFirstChild("jamarcus_SrvScrptSrv_dep") then
		game:GetService("ServerScriptService"):FindFirstChild("jamarcus_SrvScrptSrv_dep"):Destroy()
	end

	print("Done! Loaded in "..os.time() - start.. " second(s)!")
	print("Prefix: "..commandPrefix)
end

function initializeCheck()
	warn("Obtaining license...")
	if license then
		for i, v in license do
			print(v)
		end
	else
		script:Remove()
		error("LICENSE NOT FOUND; This copy is not a valid copy of JamarcusAdmin.\nPlease obtain proper license from the official model.")
	end
	
	warn("Checking version...")
	if currentVersion ~= dependencymodule.version and settingsModule.auto_update == false then
		warn("========== VERSION DEPRECATED; Update asap for security and new features or enable auto-updates! ==========")
		for _, v in playerService:GetPlayers() do
			if isAdmin(v.Name) then
				notifyUi(v, "System version deprecated!\nVersion: ["..currentVersion.."]\nPlease enable\nauto-updates or\nget newest version!")
			end
		end
		initComponents()
	elseif currentVersion ~= dependencymodule.version and settingsModule.auto_update == true then
		if not unstable then
			reload_system()
		end
	else
		print("System version up to date!")
		initComponents()
	end
end

initializeCheck()

game.Players.PlayerAdded:Connect(onPlayerAdded)