@ViewSchema = 

	db: new Mongo.Collection('view-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'widgets'
	]

	new: ->
		'name': 					null
		'description':				null
		'widgets':					null
		'blueprint_id': 			null