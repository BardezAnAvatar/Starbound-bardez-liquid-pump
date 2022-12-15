
liquidCompressionDisplay = {}


function liquidCompressionDisplay.receiveData(level)
	if storage == nil then
		storage = {}
	end

	storage.liquidCompressionLevel = level
	storage.displayCompressionLevel = "00000" .. tostring(level)
end