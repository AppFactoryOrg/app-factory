@Utils =

	removeFromArray: (item, array) ->
		index = array.indexOf(item)
		return unless index >= 0
		array.splice(index, 1)

	mapToArray: (map) ->
		results = []
		_.forIn map, (entry, key) ->
			result = _.clone(entry)
			result['name'] = key
			results.push(result)
		return results

