Meteor.methods
	'ErrorLog.create': (parameters) ->
		error_log = ErrorLog.new(parameters)
		error_log['_id'] = ErrorLog.db.insert(error_log)

		return error_log['_id']
