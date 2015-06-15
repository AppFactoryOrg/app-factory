@RoutineService =

	SERVICE_TYPE: 
		'Logic':	 	{value: 'logic', name: 'Logic'}
		'Workflow': 	{value: 'workflow', name: 'Workflow'}
		'Data': 		{value: 'data', name: 'Data'}

	NODE_TYPE:
		'Inflow':		{value: 'inflow'}
		'Outflow':		{value: 'outflow'}
		'Input':		{value: 'input'}
		'Output':		{value: 'output'}

	new: (paramaters) ->
		'id': parameters['id']
		'name': parameters['name']
		'description': parameters['description']
		'position': {x: 0, y: 0}
		'configuration': parameters['configuration']
		'nodes': parameters['nodes']
		'execute': parameters['execute']

	registry: []
	register: (service) ->
		@registry.push(service)
