@Blueprint = 

	db: new Mongo.Collection('blueprint')

	STATUS:
		'Draft':		0
		'Finalized':	1

	new: ->
		'version':					null
		'status':					null
		'application_id': 			null
