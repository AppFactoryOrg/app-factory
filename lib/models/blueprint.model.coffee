@Blueprint = 

	db: new Mongo.Collection('blueprint')

	STATUS:
		'Draft':		{value: 100}
		'Finalized':	{value: 200}

	MUTABLE_PROPERTIES: [
		'layout'
		'theme'
	]

	new: ->
		'version':					'1.0.0'
		'status':					Blueprint.STATUS['Draft'].value
		'layout':					{'navigation_items': []}
		'theme':					{}
		'application_id': 			null
