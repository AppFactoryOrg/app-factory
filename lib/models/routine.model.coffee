@Routine =
	
	db: new Mongo.Collection('routines')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'services'
		'connections'
	]

	TYPE:
		'General':		{value: 100}
		'Attribute':	{value: 200}
		'Action':		{value: 300}

	new: (parameters) ->
		'name':				parameters['name']
		'description':		parameters['description']
		'type':				parameters['type']
		'services':			[]
		'connections':		[]
		'blueprint_id':		parameters['blueprint_id']

	execute: (routine, inputs) ->
		console.log("Executine routine '#{routine.name}'...")

		return
