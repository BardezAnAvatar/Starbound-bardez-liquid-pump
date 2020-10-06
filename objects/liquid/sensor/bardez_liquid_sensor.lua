function init()
	if storage == nil then
		storage = {}
	end

	storage.position = storage.position or entity.position()
end


function update(dt)
	--LiquidLevel
	--	Simple array of two values (not an object) returned by various world functions.
	--	  int liquidId
	--	  float amount
	local liquidLevel = world.liquidAt(storage.position)

	if liquidLevel and liquidLevel[2] then
		local amount = math.floor(liquidLevel and liquidLevel[2] or 0)

		if amount < 10 then
			animator.setAnimationState("needleState", "normal")
			emitState(amount)
		elseif amount < 701 then
			animator.setAnimationState("needleState", "operating")
			emitState(amount)
		else --   > 700
			animator.setAnimationState("needleState", "faulting")
			emitState(amount)
		end
	else
		emitState(0)
	end
end


function onNodeConnectionChange()
	storage.targets = object.getOutputNodeIds(1)
end


function emitState(level)
	if level < 1000 then
		--output true, that it is safe to continue
		object.setOutputNodeLevel(0, true)
	else
		--output false, that it is NOT safe to continue
		object.setOutputNodeLevel(0, false)
	end

	--emit the level to every connected wire
	if storage.targets then
		for key in pairs(storage.targets)
			do pushGaugeLevel(storage.targets[key], level)
		end
	end
end


function pushGaugeLevel(objectId, level)
sb.logInfo("objectId: " .. tostring(objectId))
sb.logInfo("level: " .. tostring(level))

	if objectId and world.entityExists(objectId) then
		world.callScriptedEntity(objectId, "liquidCompressionDisplay.receiveData", level)
	end
end