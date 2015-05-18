@_ = lodash # Overwrite underscore with lodash

@Utils =

	removeFromArray: (item, array) ->
		index = array.indexOf(item)
		return unless index >= 0
		array.splice(index, 1)

	mapToArray: (map) ->
		results = []
		for key, entry of map
			result = _.clone(entry)
			result['name'] = key
			results.push(result)
		return results