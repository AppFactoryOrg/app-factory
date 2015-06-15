RoutineService.register
	'id': 'output'
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'name': 'Output'
	'description': "An output value for the routine"
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