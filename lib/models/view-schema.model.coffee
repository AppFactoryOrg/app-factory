@ViewSchema = 

	db: new Mongo.Collection('view-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'widgets'
	]

	new: ->
		'name': 			null
		'description':		null
		'widgets':			[]
		'blueprint_id': 	null
