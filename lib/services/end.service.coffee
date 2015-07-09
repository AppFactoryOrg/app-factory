RoutineService.registerTemplate
	'name': 'end'
	'label': 'End'
	'description': "The end point of a routine's workflow"
	'color': '#df706c'
	'display_order': 300
	'size': {height: 60, width: 60}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'flags': []
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
			position: 'Left'
		}
	]

	describeConfiguration: (service) -> ""

	execute: ->
		return []
