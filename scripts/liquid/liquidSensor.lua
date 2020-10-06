
liquidCompressionDisplay = {}


function liquidCompressionDisplay.receiveData(level)
	if storage == nil then
		storage = {}
	end

	storage.liquidCompressionLevel = level
	storage.displayCompressionLevel = "00" .. tostring(level)
end