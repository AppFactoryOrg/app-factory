@Environment = 

	db: new Mongo.Collection('environment')

	TYPE:
		'Development': 		100
		'Production':		200

	new: ->
		'name': 					null
		'type':						null
		'application_id': 			null
		'blueprint_id': 			null
