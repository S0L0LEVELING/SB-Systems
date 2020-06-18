



function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

RespawnPed = function()
	TriggerEvent('disc-death:revive')
 end




KneelMedic = function()
    local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 

	        loadAnimDict( "amb@medic@standing@tendtodead@enter" )
	        loadAnimDict( "amb@medic@standing@timeofdeath@enter" )
	        loadAnimDict( "amb@medic@standing@tendtodead@idle_a" )
	        loadAnimDict( "random@crash_rescue@help_victim_up" )

			TaskPlayAnim( player, "amb@medic@standing@tendtodead@enter", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
			TaskPlayAnim( player, "amb@medic@standing@tendtodead@idle_a", "idle_b", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
			Wait (3000)
			TaskPlayAnim( player, "amb@medic@standing@tendtodead@exit", "exit_flee", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
            TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "enter", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  
            Wait (500)
            TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "helping_victim_to_feet_player", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  

    end
end


loadAnimDict = function(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end


loadanimdict = function(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end



getVehicleInDirection = function(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end



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



RegisterCommand("uncuff", function(source, args, raw)
	if PlayerData.job.name == 'police' then
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 3.0 then
			TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
		else
			TriggerEvent('ShortText', 'Not Close Enough To Uncuff',2)

		end
	end
end, false)

