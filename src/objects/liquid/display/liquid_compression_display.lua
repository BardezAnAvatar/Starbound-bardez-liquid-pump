require "/scripts/liquid/liquidSensor.lua"


function init()
	if storage == nil then
		storage = {}
	end
end


function update(dt)
	local active = (object.isInputNodeConnected(0)) or object.getInputNodeLevel(0)
	local compressed = storage.displayCompressionLevel and storage.liquidCompressionLevel

	if compressed and active then
		if storage.liquidCompressionLevel <= 999 then
			animator.setAnimationState("one", string.sub(storage.displayCompressionLevel,-1))
			animator.setAnimationState("ten", string.sub(storage.displayCompressionLevel,-2,-2))
			animator.setAnimationState("hundred", string.sub(storage.displayCompressionLevel,-3,-3))
		else
			animator.setAnimationState("one", "excess")
			animator.setAnimationState("ten", "excess")
			animator.setAnimationState("hundred", "excess")
		end
	else
		animator.setAnimationState("one", "invalid")
		animator.setAnimationState("ten", "invalid")
		animator.setAnimationState("hundred", "invalid")
	end
end