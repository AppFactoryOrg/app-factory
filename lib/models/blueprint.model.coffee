@Blueprint = 

	db: new Mongo.Collection('blueprint')

	STATUS:
		'Draft':		{value: 100}
		'Finalized':	{value: 200}

	new: ->
		'version':					null
		'status':					null
		'application_id': 			null
