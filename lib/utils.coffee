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

	getNextId: (entity, attributeName) ->
		allIds = _.pluck(entity[attributeName], 'id')
		return 1 if _.isEmpty(allIds)
		highestId = _.first(allIds.sort((a,b) -> a < b))
		highestId++ 
		return highestId

