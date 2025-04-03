lib.versionCheck('MattiVboiii/matti-airsoft')
-- Framework detection
local framework = GetResourceState('qb-core') == 'started' and 'qb' or GetResourceState('ox_core') == 'started' and 'ox' or 'qb'
if Config.Framework == 'ox' then
    lib = exports.ox_core:GetCoreObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Update GetPlayer function to handle both frameworks
local function GetPlayer(playerId)
    if Config.Framework == 'ox' then
        return lib.GetPlayer(playerId)
    else
        return QBCore.Functions.GetPlayer(playerId)
    end
end

-- Utility function to get player name
local function GetPlayerNameById(playerId)
	local player = QBCore.Functions.GetPlayer(playerId)
	if player and player.PlayerData.charinfo then
		return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
	else
		return 'Unknown Player'
	end
end

-- Handle a player's item addition or removal with server-side validation
local function HandlePlayerItem(playerId, itemName, amount, action)
    local player = GetPlayer(playerId)
    if not player then return false end

    if Config.InventorySystem == 'ox_inventory' then
        if action == 'add' then
            return exports.ox_inventory:AddItem(playerId, itemName, amount)
        elseif action == 'remove' then
            return exports.ox_inventory:RemoveItem(playerId, itemName, amount)
        end
    else
        if action == 'add' then
            return player.Functions.AddItem(itemName, amount)
        elseif action == 'remove' then
            return player.Functions.RemoveItem(itemName, amount)
        end
    end
    return false
end

-- Utility function to handle weapon removal from player ped with safety checks
local function RemoveWeaponFromPlayerPed(playerId, weaponName)
	if not playerId or not weaponName then
		return false
	end

	-- Trigger client-side check and removal
	TriggerClientEvent('matti-airsoft:client:removeWeaponFromPed', playerId, weaponName)
	return true
end

-- Event to revive a player after they are killed in the airsoft zone
RegisterServerEvent('matti-airsoft:revivePlayer')
AddEventHandler('matti-airsoft:revivePlayer', function()
	local src = source
	TriggerClientEvent('hospital:client:Revive', src)
end)

-- Check if a player can afford a given loadout
QBCore.Functions.CreateCallback('matti-airsoft:canAffordLoadout', function(source, cb, price)
    local player = GetPlayer(source)
    if not player then cb(false) return end

    if Config.Framework == 'ox' then
        local money = player.getAccount('money').money
        if money >= price then
            player.removeMoney(price, 'Airsoft Loadout')
            cb(true)
        else
            cb(false)
        end
    else
        if player.Functions.RemoveMoney('cash', price, 'airsoft') then
            cb(true)
        else
            cb(false)
        end
    end
end)

-- Debugging entry point
-- Event to debug zone entry
-- This is useful for testing the zone trigger
RegisterServerEvent('matti-airsoft:debugZoneEntry')
AddEventHandler('matti-airsoft:debugZoneEntry', function(playerName, action)
	if Config.Debug then
		print(playerName .. ' has ' .. action .. ' the airsoft zone.')
	end
end)

--[[
Events for handling items and weapons
]]

-- Event to give a player a weapon
RegisterServerEvent('matti-airsoft:giveWeapon')
AddEventHandler('matti-airsoft:giveWeapon', function(weaponName)
	-- Handle the weapon addition
	HandlePlayerItem(source, weaponName, 1, 'add')
end)

-- Event to give a player an item
RegisterServerEvent('matti-airsoft:giveItem')
AddEventHandler('matti-airsoft:giveItem', function(itemName, amount)
	-- Handle the item addition
	HandlePlayerItem(source, itemName, amount, 'add')
end)

-- Event to remove a weapon from a player
RegisterServerEvent('matti-airsoft:removeWeapon')
AddEventHandler('matti-airsoft:removeWeapon', function(weaponName)
	-- Handle the weapon removal
	HandlePlayerItem(source, weaponName, 1, 'remove')
	-- Remove the weapon from the player's ped
	RemoveWeaponFromPlayerPed(source, weaponName)
end)

-- Event to remove an item from a player
RegisterServerEvent('matti-airsoft:removeItem')
AddEventHandler('matti-airsoft:removeItem', function(itemName, amount)
	-- Handle the item removal
	HandlePlayerItem(source, itemName, amount, 'remove')
end)

QBCore.Commands.Add(
	'exitarena',
	Lang:t('command.description_exitarena'),
	{ { name = 'id', help = Lang:t('command.help_exitarena') } },
	false,
	function(source, args)
		-- Parse the player ID from the arguments or default to the source
		local playerId = tonumber(args[1]) or source
		if playerId then
			-- Attempt to retrieve the target player object
			local targetPlayer = QBCore.Functions.GetPlayer(playerId)
			if targetPlayer then
				-- Trigger client event to check if the player is in the arena
				TriggerClientEvent('matti-airsoft:checkIfInArena', playerId, source)
			else
				-- Notify the source that the player ID is invalid
				TriggerClientEvent(
					'matti-airsoft:sendNotification',
					source,
					Lang:t('command.invalid_player_id'),
					'error'
				)
			end
		else
			-- Notify the source that the provided player ID is invalid
			TriggerClientEvent('matti-airsoft:sendNotification', source, Lang:t('command.invalid_player_id'), 'error')
		end
	end,
	'admin'
)

-- Handle reporting of arena status to the server
RegisterNetEvent('matti-airsoft:reportArenaStatus')
AddEventHandler('matti-airsoft:reportArenaStatus', function(adminId, isInArena)
	if isInArena then
		-- Force the player to exit the arena
		TriggerClientEvent('matti-airsoft:forceExitArena', source)
		-- Send a success notification to the admin
		TriggerClientEvent('matti-airsoft:sendNotification', adminId, Lang:t('command.player_removed'), 'success')
	else
		-- Send an error notification to the admin
		TriggerClientEvent('matti-airsoft:sendNotification', adminId, Lang:t('command.player_not_in_arena'), 'error')
	end
end)
