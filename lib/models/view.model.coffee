@View = 

	db: new Mongo.Collection('view')

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