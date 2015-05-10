@Blueprint = 

	db: new Mongo.Collection('blueprint')

	STATUS: [
		{name: 'Draft',			value: 100}
		{name: 'Finalized',		value: 200}
	]

	new: ->
		'version':					null
		'status':					null
		'application_id': 			null
