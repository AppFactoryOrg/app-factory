RoutineService.register
	'name': 'end'
	'label': 'End'
	'description': "The end point of a routine's workflow"
	'color': '#d9534f'
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'configuration': {}
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
		}
	]
	'execute': -> 
		return [{node: 'out'}]
