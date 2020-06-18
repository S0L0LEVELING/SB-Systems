ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('SB:drag')
AddEventHandler('SB:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('SB:drag', target, source)
end)



-- seating 

	RegisterServerEvent('pol:putInVehicle')
	AddEventHandler('pol:putInVehicle', function(target)
		TriggerClientEvent('pol:putInVehicle', target)
	end)

	RegisterServerEvent('pol:OutVehicle')
	AddEventHandler('pol:OutVehicle', function(target)
		TriggerClientEvent('pol:OutVehicle', target)
	end)


-- Escorting

	RegisterServerEvent("Drag")
	AddEventHandler("Drag", function(Target)
		local Source = source
		TriggerClientEvent("Drag", Target, Source)
	end)


-- Revive
	-- RegisterCommand('revive', function(source)
	-- 	TriggerClientEvent('revive', source)
	-- end)


	RegisterServerEvent('reviveGranted')
	AddEventHandler('reviveGranted', function(target)
		TriggerClientEvent('Revive:revive',target)
	
	end)


	RegisterServerEvent('ReviveTarget')
	AddEventHandler('ReviveTarget', function(target)
		TriggerClientEvent('Revive:revive', target)
	end)

	RegisterCommand("reviveID", function(src, args)

		local xPlayer = ESX.GetPlayerFromId(src)

		if xPlayer["job"]["name"] == "police" or "ambulance" then

			local target = args[1]

			if GetPlayerName(target) ~= nil then
				Revive(target)
			else
				TriggerEvent('ShortText',src, ' ID invalid' , 2)
			end
		else
			TriggerEvent('ShortText',src, 'You an officer? LOL' , 2)
		end
	end)


	function Revive(target)
		TriggerClientEvent('Revive:revive',target)
	end

-- item or job check

	RegisterServerEvent("sb-hardHasCuff")
	AddEventHandler("sb-hardHasCuff", function(targetid, playerheading, playerCoords,  playerlocation)
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(_source)
		local sourceXPlayer = ESX.GetPlayerFromId(_source)

		if xPlayer.getInventoryItem("handcuffs").count > 0 or sourceXPlayer.job.name == 'police'  then
			TriggerEvent('pol:requestarresthard', targetid, playerheading, playerCoords,  playerlocation)
			TriggerClientEvent('pol:doarrested', _source)
		else
			TriggerClientEvent('DoLongHudText', source, 'You dont have handcuffs' ,1, 7000)
		end
	end)

	RegisterServerEvent("sb-itemSoftCuff")
	AddEventHandler("sb-itemSoftCuff", function(targetid, playerheading, playerCoords,  playerlocation)
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(_source)
		local sourceXPlayer = ESX.GetPlayerFromId(_source)

		if xPlayer.getInventoryItem("handcuffs").count > 0  or sourceXPlayer.job.name == 'police' then
			TriggerEvent('pol:requestarrest', targetid, playerheading, playerCoords,  playerlocation)
			TriggerClientEvent('pol:doarrested', _source)
		else
			TriggerClientEvent('DoLongHudText', source, 'You dont have handcuffs' ,1, 7000)
		end
	end)

	RegisterServerEvent("sb-itemUncuff")
	AddEventHandler("sb-itemUncuff", function(targetid, playerheading, playerCoords,  playerlocation)
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(_source)
		local sourceXPlayer = ESX.GetPlayerFromId(_source)

		if xPlayer.getInventoryItem("handcuffs").count > 0 or sourceXPlayer.job.name == 'police' then
			TriggerEvent('pol:requestrelease', targetid, playerheading, playerCoords,  playerlocation)
		else
			TriggerClientEvent('DoLongHudText', source, 'You dont have handcuffs' ,1, 7000)
		end
	end)


-- Hard Cuff
	RegisterServerEvent('pol:requestarresthard')
	AddEventHandler('pol:requestarresthard', function(targetid, playerheading, playerCoords,  playerlocation)
	    _source = source
	    TriggerClientEvent('pol:gethardarrested', targetid, playerheading, playerCoords, playerlocation)
	end)

	--softcuff
	RegisterServerEvent('pol:requestarrest')
	AddEventHandler('pol:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	    _source = source
	    TriggerClientEvent('pol:getarrested', targetid, playerheading, playerCoords, playerlocation)
	end)

	--uncuff
	RegisterServerEvent('pol:requestrelease')
	AddEventHandler('pol:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	    _source = source
	    TriggerClientEvent('pol:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	end)


