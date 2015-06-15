RoutineService.register
	'name': 'output'
	'label': 'Output'
	'description': "An output value for the routine"
	'color': '#70678E'
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'configuration':
		'name': ''
		'data_type': null
	'nodes': [
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Input'].value
		}
	]
	'execute': ({service, routineInputs}) -> 
		return []