RoutineService.register
	'id': 'start'
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'name': 'Start'
	'description': "The entry point for a routine's workflow"
	'configuration': {}
	'nodes': [
		{
			name: 'out'
			type: RoutineService.NODE_TYPE['Outflow'].value
		}
	]
	'execute': -> 
		return [{node: 'out'}]
