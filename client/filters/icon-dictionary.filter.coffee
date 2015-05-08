angular.module('app-factory').filter 'iconDictionary', () ->
	return (input, map) ->
		result = ''
		for option in map
			result = option.iconClass if option.value is input

		return result
