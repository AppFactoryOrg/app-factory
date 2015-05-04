@Application = 

	db: new Mongo.Collection('application')

	new: ->
		'name': 					null
		'owner_id': 				null