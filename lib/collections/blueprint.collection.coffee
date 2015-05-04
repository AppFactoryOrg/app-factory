@Blueprint = 

	db: new Mongo.Collection('blueprint')

	new: ->
		'version':					null
		'application_id': 			null
