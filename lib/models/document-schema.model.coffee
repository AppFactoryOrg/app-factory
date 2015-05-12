@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
	]

	new: ->
		'name': 			null
		'description':		null
		'attributes':		[]
		'blueprint_id': 	null