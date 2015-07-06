@_ = lodash # Overwrite underscore with lodash

@Utils =

	logError: (error) ->
		error_log = Utils.parseError(error)
		Meteor.call('ErrorLog.create', error_log)

	logErrors: (callback) ->
		try
			callback()
		catch error
			error_log = Utils.parseError(error)
			Meteor.call('ErrorLog.create', error_log)

			throw error

	parseError: (error) ->
		if error.message?
			message = error.message
		else if error.error?
			message = error.error
		else
			message = ''

		if error.stack?
			stack = error.stack
		else
			stack = ''

		return {
			'origin': if Meteor.isClient then 'client' else 'server'
			'message': message
			'stack': stack
		}

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
