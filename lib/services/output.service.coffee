RoutineService.registerTemplate
	'name': 'output'
	'label': 'Output'
	'description': "An output value for the routine"
	'color': '#df706c'
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'name': ''
		'data_type': null
	'nodes': [
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Input'].value
			position: 'Left'
		}
	]

	describeConfiguration: (service) ->
		return "Name - Type"

	execute: ({service, routineInputs}) -> 
		return []