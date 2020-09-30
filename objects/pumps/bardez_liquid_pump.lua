require "/scripts/kheAA/transferUtil.lua"
require "/scripts/util.lua"
require "/scripts/vec2.lua"

function init()
	isInstance=world.getProperty("ephemeral")
	self.inputLocation = entity.position()
	storage.entityId = entity.entityId()
	checkInput()
	animate()
end


function checkInput()
	storage.currentState = setCurrentOutput() and (not object.isOutputNodeConnected(0) or object.getInputNodeLevel(0))
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


function outputnodes()
	object.setOutputNodeLevel(transferUtil.vars.outDataNode,not transferUtil.vars.containerId==nil)
end


function update(dt)
	if not self.timer2 or self.timer2 <= 0 then
		checkInput()
		local hasPumpedLiquid = false

		if storage.currentState then
			hasPumpedLiquid = pumpLiquid()
			self.timer2 = dt * ((hasMovedLiquid and not isInstance) and 1 or 0)			
			outputnodes()
			animate()
		end
	else
		self.timer2 = self.timer2 - dt
	end
end


function pumpLiquid()
	--LiquidLevel
	--	Simple array of two values (not an object) returned by various world functions.
	--	  int liquidId
	--	  float amount
	local inputLiquid = world.forceDestroyLiquid(self.inputLocation)

	if inputLiquid and inputLiquid[2] > 0.0 then
		local liquidData = root.liquidConfig(inputLiquid[1])

		if liquidData and liquidData.config and liquidData.config.itemDrop then

			local spawn = { count=liquidData[2], parameters={}, name=liquidData.config.itemDrop }
			
			--check if we have the capacity
			local capacity = world.containerItemsCanFit(storage.entityId, spawn.name) or 0
			if (capacity > 0) then

				--turn float liquid into items; remainder remains liquid
				local fullAmount = spawn.count
				local itemCount = math.floor(spawn.count)
				if (itemCount > capacity) then
					itemCount = capacity
				end
				
				local remainingAmount = fullAmount - itemCount
				spawn.count = itemCount

				--if non-zero, spawn items
				if spawn.count > 0 then
					world.spawnItem(spawn, self.inputLocation)
				end

				--if there is any remainder, re-spawn the liquid at its source
				if buffer > 0.0 then
					world.spawnLiquid(self.inputLocation, inputLiquid[1], remainingAmount)
				end

				return true
			end
		end
	end
	return false
end