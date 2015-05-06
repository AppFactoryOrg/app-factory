angular.module('app-factory').filter 'dictionary', () ->
	return (input, map) ->
		result = ''
		_.forIn map, (value, key) ->
			result = key if value is input

		return result
