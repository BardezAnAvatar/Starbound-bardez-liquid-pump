require "/scripts/liquid/liquidSensor.lua"


function init()
	if storage == nil then
		storage = {}
	end

	-- Load the digits once on init so we don't fetch it OVER AND OVER
	storage.displayDigits = {}
	storage.displayDigits.one = config.getParameter("displayDigits.one", false)
	storage.displayDigits.ten = config.getParameter("displayDigits.ten", false)
	storage.displayDigits.hundred = config.getParameter("displayDigits.hundred", false)
	storage.displayDigits.thousand = config.getParameter("displayDigits.thousand", false)
	storage.displayDigits.tenThousand = config.getParameter("displayDigits.tenThousand", false)

	-- Same with the pressure maximum
	storage.pressureMax = config.getParameter("pressureMax", 9)
end


function update(dt)
	local active = (object.isInputNodeConnected(0)) or object.getInputNodeLevel(0)
	local compressed = storage.displayCompressionLevel and storage.liquidCompressionLevel

	if compressed and active then
		if storage.liquidCompressionLevel <= storage.pressureMax then
			setDigit("one", string.sub(storage.displayCompressionLevel,-1))
			setDigit("ten", string.sub(storage.displayCompressionLevel,-2,-2))
			setDigit("hundred", string.sub(storage.displayCompressionLevel,-3,-3))
			setDigit("thousand", string.sub(storage.displayCompressionLevel,-4,-4))
			setDigit("tenThousand", string.sub(storage.displayCompressionLevel,-5,-5))
		else
			setDigit("one", "excess")
			setDigit("ten", "excess")
			setDigit("hundred", "excess")
			setDigit("thousand", "excess")
			setDigit("tenThousand", "excess")
		end
	else
		setDigit("one", "invalid")
		setDigit("ten", "invalid")
		setDigit("hundred", "invalid")
		setDigit("thousand", "invalid")
		setDigit("tenThousand", "invalid")
	end
end

function setDigit(digit, value)
	local hasDigit = storage.displayDigits[digit]

	if hasDigit then
		animator.setAnimationState(digit, value)
	end
end