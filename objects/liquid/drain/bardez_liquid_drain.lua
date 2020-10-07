require "/scripts/kheAA/transferUtil.lua"
require "/scripts/util.lua"
require "/scripts/vec2.lua"

function init()

	if storage == nil then
		storage = {}
	end

	if storage.init == nil then
		storage.init = true
	end

	storage.position = storage.position or entity.position()
	storage.entityId = entity.id()
	isInstance = world.getProperty("ephemeral")
	checkInput()
	animate()
	TransferInit()
end


function TransferInit()
	transferUtil.init()
	transferUtil.vars.inContainers={}
	transferUtil.vars.outContainers={}
	transferUtil.vars.containerId=nil
	self.containerPos={0,0}
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


function outputnodes()
	transferUtil.loadSelfContainer()
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
	local inputLiquid = world.forceDestroyLiquid(storage.position)

	if inputLiquid and inputLiquid[2] > 0.0 then
		local liquidData = root.liquidConfig(inputLiquid[1])

		if liquidData and liquidData.config and liquidData.config.itemDrop then

			local spawn = { name = liquidData.config.itemDrop, count = inputLiquid[2], parameters = {} }

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
					local inserted = world.containerAddItems(storage.entityId, spawn)

					--if we were not able to insert the liquid into the pump, emit it back out
					if ((inserterted and inserted.count) or 0 > 0) then
						remainingAmount = remainingAmount + inserted.count
					end
				end

				--if there is any remainder, re-spawn the liquid at its source
				if remainingAmount > 0.0 then
					world.spawnLiquid(storage.position, inputLiquid[1], remainingAmount)
				end

				return true
			end
		end
	end
	return false
end