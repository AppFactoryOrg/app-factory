RoutineService.register
	'id': 'end'
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'name': 'End'
	'description': "The end point of a routine's workflow"
	'configuration': {}
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
		}
	]
	'execute': -> 
		return [{node: 'out'}]
