@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
	]

	new: ->
		'name': 					null
		'description':				null
		'attributes':				null
		'blueprint_id': 			null