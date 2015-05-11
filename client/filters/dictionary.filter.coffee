angular.module('app-factory').filter 'dictionary', () ->
	return (input, map, propertyName) ->
		result = ''
		propertyName = 'name' unless propertyName?
		for entry in map
			result = entry[propertyName] if entry['value'] is input

		return result
