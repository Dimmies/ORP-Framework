localization = {}

function _(str, ...)

	if localization[SERVER_LANGUAGE] ~= nil then

		if localization[SERVER_LANGUAGE][str] ~= nil then
			return string.format(localization[SERVER_LANGUAGE][str], ...)
		else
			return 'Translation [' .. SERVER_LANGUAGE .. '][' .. str .. '] does not exist'
		end

	else
		return 'The languange [' .. SERVER_LANGUAGE .. "] does not exist."
	end

end