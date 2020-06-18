ESX = nil
local dragStatus = {}
dragStatus.isDragged = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

--cuffing
	RegisterNetEvent("SB-Cuffing")
	AddEventHandler("SB-Cuffing", function()
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 2.0 then
			TriggerServerEvent('sb-hardHasCuff', target_id, playerheading, playerCoords, playerlocation)
		else
			TriggerEvent('DoLongHudText','Not Close Enough To Target',2, 6000)
		end
	end)

	RegisterNetEvent("SB-SoftCuff")
	AddEventHandler("SB-SoftCuff", function()
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 2.0 then
			TriggerServerEvent('sb-itemSoftCuff', target_id, playerheading, playerCoords, playerlocation)
		else
			TriggerEvent('DoLongHudText','Not Close Enough To Target',2, 6000)
		end
	end)

	RegisterNetEvent("SB-Uncuff")
	AddEventHandler("SB-Uncuff", function()
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 2.0 then
			TriggerServerEvent('sb-itemUncuff', target_id, playerheading, playerCoords, playerlocation)
		else
			TriggerEvent('DoLongHudText','Not Close Enough To Target',2, 6000)
		end
	end)

	RegisterNetEvent('pol:getarrested')
	AddEventHandler('pol:getarrested', function(playerheading, playercoords, playerlocation)
		playerPed = GetPlayerPed(-1)
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
		SetEntityCoords(GetPlayerPed(-1), x, y, z)
		SetEntityHeading(GetPlayerPed(-1), playerheading)
		Citizen.Wait(250)
		loadanimdict('mp_arrest_paired')
		TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
		Citizen.Wait(3760)
		isHandcuffed = true
		shackles = false
		loadanimdict('mp_arresting')
		TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end)


	RegisterNetEvent('pol:gethardarrested')
	AddEventHandler('pol:gethardarrested', function(playerheading, playercoords, playerlocation)
		playerPed = GetPlayerPed(-1)
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
		SetEntityCoords(GetPlayerPed(-1), x, y, z)
		SetEntityHeading(GetPlayerPed(-1), playerheading)
		Citizen.Wait(250)
		loadanimdict('mp_arrest_paired')
		TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
		Citizen.Wait(3760)
		isHandcuffed = true
		shackles = true
		loadanimdict('mp_arresting')
		TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end)

	RegisterNetEvent('pol:doarrested')
	AddEventHandler('pol:doarrested', function()
		Citizen.Wait(250)
		loadanimdict('mp_arrest_paired')
		TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
		Citizen.Wait(3000)

	end) 


	RegisterNetEvent('pol:getuncuffed')
	AddEventHandler('pol:getuncuffed', function(playerheading, playercoords, playerlocation)
		isHandcuffed = false
		shackles = false
		ClearPedTasks(GetPlayerPed(-1))
	end)


	-- Handcuff
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local playerPed = PlayerPedId()

			if isHandcuffed then
				DisableControlAction(0, 1, true) -- Disable pan
				DisableControlAction(0, 2, true) -- Disable tilt
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Aim
				DisableControlAction(0, 263, true) -- Melee Attack 1

				DisableControlAction(0, 45, true) -- Reload
				DisableControlAction(0, 44, true) -- Cover
				DisableControlAction(0, 37, true) -- Select Weapon
				DisableControlAction(0, 23, true) -- Also 'enter'?

				DisableControlAction(0, 288,  true) -- Disable phone
				DisableControlAction(0, 289, true) -- Inventory
				DisableControlAction(0, 170, true) -- Animations
				DisableControlAction(0, 167, true) -- Job

				DisableControlAction(0, 0, true) -- Disable changing view
				DisableControlAction(0, 26, true) -- Disable looking behind
				DisableControlAction(0, 73, true) -- Disable clearing animation
				DisableControlAction(2, 199, true) -- Disable pause screen

				DisableControlAction(0, 59, true) -- Disable steering in vehicle
				DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
				DisableControlAction(0, 72, true) -- Disable reversing in vehicle

				DisableControlAction(2, 36, true) -- Disable going stealth

				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle

				if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
					ESX.Streaming.RequestAnimDict('mp_arresting', function()
						TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
					end)
				end
			else
				Citizen.Wait(500)
			end
		end
	end)

	-- shackles
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local playerPed = PlayerPedId()

			if shackles then
				DisableControlAction(0, 32, true) -- W
				DisableControlAction(0, 34, true) -- A
				DisableControlAction(0, 31, true) -- S
				DisableControlAction(0, 30, true) -- D
				DisableControlAction(0, 22, true) -- Jump

				if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
					ESX.Streaming.RequestAnimDict('mp_arresting', function()
						TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
					end)
				end
			else
				Citizen.Wait(500)
			end
		end
	end)



-- Reviving 

	RegisterNetEvent('revive')
	AddEventHandler('revive', function()
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if target ~= nil then

			if distance <= 2.0 then
				TriggerServerEvent('reviveGranted', target_id)
				KneelMedic()
			end
		else
			TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
		end

	end)

	RegisterNetEvent('reviveCommand')
	AddEventHandler('reviveCommand', function(target)
		TriggerServerEvent("ReviveTarget",target)

	end)

	RegisterNetEvent('Revive:revive')
	AddEventHandler('Revive:revive', function(target)
		local playerPed = target
		local coords = GetEntityCoords(playerPed)
		print('reviveID')
		Citizen.CreateThread(function()
			TriggerEvent('playerSpawned', coords)
			RespawnPed(target)

		end)
	end)





-- Escorting

	local Drag = {
		Distance = 3,
		Dragging = false,
		Dragger = -1,
		Dragged = false,
	}

	function Drag:GetPlayers()
		local Players = {}
	    
		for Index = 0, 255 do
			if NetworkIsPlayerActive(Index) then
				table.insert(Players, Index)
			end
		end

	    return Players
	end

	function Drag:GetClosestPlayer()
	    local Players = self:GetPlayers()
	    local ClosestDistance = -1
	    local ClosestPlayer = -1
	    local PlayerPed = PlayerPedId()
	    local PlayerPosition = GetEntityCoords(PlayerPed, false)
	    
	    for Index = 1, #Players do
	    	local TargetPed = GetPlayerPed(Players[Index])
	    	if PlayerPed ~= TargetPed then
	    		local TargetCoords = GetEntityCoords(TargetPed, false)
	    		local Distance = #(PlayerPosition - TargetCoords)

	    		if ClosestDistance == -1 or ClosestDistance > Distance then
	    			ClosestPlayer = Players[Index]
	    			ClosestDistance = Distance
	    		end
	    	end
	    end
	    
	    return ClosestPlayer, ClosestDistance
	end

	RegisterNetEvent("Drag")
	AddEventHandler("Drag", function(Dragger)
		Drag.Dragging = not Drag.Dragging
		Drag.Dragger = Dragger
	end)

	RegisterNetEvent("escortplayer")
	AddEventHandler("escortplayer", function(Dragger)
		local Player, Distance = Drag:GetClosestPlayer()
		if Distance ~= -1 and Distance < Drag.Distance then
			TriggerServerEvent("Drag", GetPlayerServerId(Player))
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if NetworkIsSessionStarted() then
				TriggerEvent("chat:addSuggestion", "/drag", "Toggle drag the closest player")
				return
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if Drag.Dragging then
				local PlayerPed = PlayerPedId()

				Drag.Dragged = true
				AttachEntityToEntity(PlayerPed, GetPlayerPed(GetPlayerFromServerId(Drag.Dragger)), 4103, 0.4, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				if Drag.Dragged then
					local PlayerPed = PlayerPedId()

					if not IsPedInParachuteFreeFall(PlayerPed) then
						Drag.Dragged = false
						DetachEntity(PlayerPed, true, false)    
					end
				end
			end
		end
	end)

-- Vehicle In and Out

RegisterNetEvent('pol:PutInVeh')
AddEventHandler('pol:PutInVeh', function(source)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 5.0 then
		TriggerServerEvent('pol:putInVehicle', GetPlayerServerId(closestPlayer))
	end
end)


RegisterNetEvent('pol:putInVehicle')
AddEventHandler('pol:putInVehicle', function()
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    if vehicle ~= nil then
        Citizen.Trace("22")
      if IsEntityAVehicle(vehicle) then
        for i=1,GetVehicleMaxNumberOfPassengers(vehicle) do
            Citizen.Trace("33")
          if IsVehicleSeatFree(vehicle,i) then
		 	Drag.Dragged = false
			DetachEntity(playerPed, true, false)   
			Citizen.Wait(100)
            SetPedIntoVehicle(PlayerPedId(),vehicle,i)
            
            return true
          end
        end
	    if IsVehicleSeatFree(vehicle,0) then
	    	Drag.Dragged = false
			DetachEntity(playerPed, true, false)   
			Citizen.Wait(100)
	        SetPedIntoVehicle(PlayerPedId(),vehicle,0)
	        
	    end
      end
    end
end)

RegisterNetEvent('pol:TakeOutveh')
AddEventHandler('pol:TakeOutveh', function(source)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 5.0 then
		TriggerServerEvent('pol:OutVehicle', GetPlayerServerId(closestPlayer))
	end
end)

RegisterNetEvent('pol:OutVehicle')
AddEventHandler('pol:OutVehicle', function()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 16)
	end
end)


-- Flip Vehicle


RegisterNetEvent('FlipVehicle')
AddEventHandler('FlipVehicle', function()
	local finished = exports["fu-taskbar"]:taskBar(3500,"Flipping Vehicle Over",false,true)	

	if finished == 100 then
		local playerped = PlayerPedId()
	    local coordA = GetEntityCoords(playerped, 1)
	    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
	    local targetVehicle = getVehicleInDirection(coordA, coordB)
		SetVehicleOnGroundProperly(targetVehicle)
	end

end)