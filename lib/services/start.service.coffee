RoutineService.registerTemplate
	'name': 'start'
	'label': 'Start'
	'description': "The entry point for a routine's workflow"
	'color': '#5cb85c'
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'nodes': [
		{
			name: 'out'
			type: RoutineService.NODE_TYPE['Outflow'].value
		}
	]
	'execute': -> 
		return [{node: 'out'}]
