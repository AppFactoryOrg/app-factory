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

	new: (parameters) ->
		'id': Meteor.uuid()
		'name': parameters['name']
		'position': parameters['position']
		'configuration': parameters['configuration']
		'node_values': []

	registry: []
	register: (service) ->
		@registry.push(service)