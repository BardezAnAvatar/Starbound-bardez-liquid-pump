require "/scripts/util.lua"
require "/scripts/vec2.lua"

function init()
	storage.position = storage.position or entity.position()
	storage.entityId = entity.id()
	isInstance = world.getProperty("ephemeral")
	checkInput()
	animate()
end


function checkInput()
	storage.currentState = not object.isInputNodeConnected(0) or object.getInputNodeLevel(0)
end


function onInputNodeChange(args)
	checkInput()
end


function onNodeConnectionChange()
	checkInput()
end


function animate()
	animator.setAnimationState("inputState", storage.currentState and "on" or "off")
end


function update(dt)
	if not self.timer or self.timer <= 0 then
		checkInput()
		local hasPumpedLiquid = false

		if storage.currentState then
			hasPumpedLiquid = pumpLiquid()
			self.timer = dt * ((hasMovedLiquid and not isInstance) and 1 or 0)
			animate()
		end
	else
		self.timer = self.timer - dt
	end
end


function pumpLiquid()
	--LiquidLevel
	--	Simple array of two values (not an object) returned by various world functions.
	--	  int liquidId
	--	  float amount
	local inputLiquid = world.forceDestroyLiquid(storage.position)

	if inputLiquid and inputLiquid[2] > 0.0 then
		local liquidData = root.liquidConfig(inputLiquid[1])

		if liquidData and liquidData.config then

			local spawn = { name = liquidData.config.itemDrop, count = inputLiquid[2], parameters = {} }

			--if there is any remainder, re-spawn the liquid at its source
			if spawn.count > 0.0 then
				world.spawnLiquid(storage.position, inputLiquid[1], spawn.count  * 1.25)
			end

			return true
		end
	end
	return false
end