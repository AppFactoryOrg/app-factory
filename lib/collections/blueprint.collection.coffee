@Blueprint = 

	db: new Mongo.Collection('blueprint')

	STATUS:
		'Draft':		100
		'Finalized':	200

	new: ->
		'version':					null
		'status':					null
		'application_id': 			null
