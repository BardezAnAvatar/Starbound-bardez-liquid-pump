
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
		local display = "00" .. tostring(amount)

		if amount <= 999 then
			animator.setAnimationState("one", string.sub(display,-1))
			animator.setAnimationState("ten", string.sub(display,-2,-2))
			animator.setAnimationState("hundred", string.sub(display,-3,-3))

			--output true, that it is safe to continue
			object.setOutputNodeLevel(0, true)
		else
			animator.setAnimationState("one", "excess")
			animator.setAnimationState("ten", "excess")
			animator.setAnimationState("hundred", "excess")

			--output false, that it is NOT safe to continue
			object.setOutputNodeLevel(0, false)
		end
	else
		animator.setAnimationState("one", "invalid")
		animator.setAnimationState("ten", "invalid")
		animator.setAnimationState("hundred", "invalid")
	end
end