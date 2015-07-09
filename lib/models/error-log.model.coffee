@ErrorLog =

	db: new Mongo.Collection('error-logs')

	new: (parameters) ->
		'origin':    parameters['origin'] # client or server
		'message':   parameters['message']
		'stack':     parameters['stack']
		'date':      Date.now()
		'user':      Meteor.userId()
