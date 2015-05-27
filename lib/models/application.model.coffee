@Application = 

	db: new Mongo.Collection('application')

	MUTABLE_PROPERTIES: [
		'name'
	]

	new: ->
		'name': 					null
		'owner_id': 				null
		'default_environment_id':	null
