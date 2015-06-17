RoutineService.registerTemplate
	'name': 'end'
	'label': 'End'
	'description': "The end point of a routine's workflow"
	'color': '#df706c'
	'size': {height: 60, width: 60}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
			position: 'Left'
		}
	]

	execute: -> 
		return [{node: 'out'}]
