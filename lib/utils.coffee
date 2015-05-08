@Utils =

	removeFromArray: (item, array) ->
		index = array.indexOf(item)
		return unless index >= 0
		array.splice(index, 1)