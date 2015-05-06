@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	new: ->
		'name': 					null
		'blueprint_id': 			null
