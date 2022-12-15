require "/scripts/liquid/liquidSensor.lua"


function init()
	if storage == nil then
		storage = {}
	end
end


function update(dt)
	local active = (object.isInputNodeConnected(0)) or object.getInputNodeLevel(0)
	local compressed = storage.displayCompressionLevel and storage.liquidCompressionLevel
	local max = config.getParameter("pressureMax", 9)

	if compressed and active then
		if storage.liquidCompressionLevel <= max then
			setDigit("one", string.sub(storage.displayCompressionLevel,-1))
			setDigit("ten", string.sub(storage.displayCompressionLevel,-2,-2))
			setDigit("hundred", string.sub(storage.displayCompressionLevel,-3,-3))
			setDigit("thousand", string.sub(storage.displayCompressionLevel,-4,-4))
			setDigit("tenthousand", string.sub(storage.displayCompressionLevel,-5,-5))
		else
			setDigit("one", "excess")
			setDigit("ten", "excess")
			setDigit("hundred", "excess")
			setDigit("thousand", "excess")
			setDigit("tenthousand", "excess")
		end
	else
		setDigit("one", "invalid")
		setDigit("ten", "invalid")
		setDigit("hundred", "invalid")
		setDigit("thousand", "invalid")
		setDigit("tenthousand", "invalid")
	end
end

function setDigit(digit, value)
	local hasDigit = config.getParameter("displayDigits." .. digit, false)

	if hasDigit then
		animator.setAnimationState(digit, value)
	end
end