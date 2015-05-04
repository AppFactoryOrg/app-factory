@Environment = 

	db: new Mongo.Collection('environment')

	TYPE:
		'Development': 		0
		'Production':		1

	new: ->
		'name': 					null
		'type':						null
		'application_id': 			null
		'blueprint_id': 			null
