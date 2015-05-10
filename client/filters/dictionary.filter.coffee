angular.module('app-factory').filter 'dictionary', () ->
	return (input, map, propertyName) ->
		result = ''
		propertyName = 'name' unless propertyName?
		for option in map
			result = option[propertyName] if option.value is input

		return result
