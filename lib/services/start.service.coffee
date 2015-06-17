RoutineService.registerTemplate
	'name': 'start'
	'label': 'Start'
	'description': "The entry point for a routine's workflow"
	'color': '#77C777'
	'display_order': 100
	'size': {height: 60, width: 60}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'nodes': [
		{
			name: 'out'
			type: RoutineService.NODE_TYPE['Outflow'].value
			position: 'Right'
		}
	]

	execute: -> 
		return [{node: 'out'}]
