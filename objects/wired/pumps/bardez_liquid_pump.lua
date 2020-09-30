require "/scripts/vec2.lua"


function init()
	isInstance=world.getProperty("ephemeral")
	self.inputLocation = object.position()
	storage.currentState = setCurrentOutput() and (not object.isOutputNodeConnected(0) or object.getInputNodeLevel(0))
	animate()
end


function animate()
	animator.setAnimationState("inputState",storage.currentState and "on" or "off")
end


function update(dt)
	if not self.timer2 or self.timer2 <= 0 then
		local hasPumpedLiquid = false

		hasPumpedLiquid = pumpLiquid()

		self.timer2 = dt * ((hasMovedLiquid and not isInstance) and 1 or 0)
		object.setAllOutputNodes(storage.currentState)
		animate()
	else
		self.timer2 = self.timer2 - dt
	end
end


function pumpLiquid()
    local inputLiquid = world.liquidAt(self.inputLocation)

	--LiquidLevel
	--  Simple array of two values (not an object) returned by various world functions.
    --    int liquidId
	--    float amount
    if inputLiquid and inputLiquid[2] > 0.1 then

        local destroyed==world.forceDestroyLiquid(isTileProtected)

		if destroyed then
			local liquidData = root.liquidConfig(inputLiquid[1])

			if liquidData and liquidData.config and liquidData.config.itemDrop then

				local spawn = { count=liquidData[2], parameters={}, name=liquidData.config.itemDrop }

				--turn float liquid into items; remainder remains liquid
				local fullAmount = spawn.count
				local itemCount = math.floor(spawn.count)
				local remainingAmount = fullAmount - itemCount
				spawn.count = itemCount

				--if non-zero, spawn items
				if spawn.count > 0 then
					world.spawnItem(spawn, entity.position())
				end

				--if there is any remainder, re-spawn the liquid at its source
				if buffer > 0.0 then
					world.spawnLiquid(entity.position(), inputLiquid[1], remainingAmount)
				end

				return true
			end
		end
    end
    return false
end