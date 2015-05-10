angular.module('app-factory').filter 'dictionary', () ->
	return (input, map) ->
		result = ''
		for option in map
			result = option.name if option.value is input

		return result
