RoutineService.registerTemplate
	'name': 'switch'
	'label': 'Switch'
	'description': "Directs the workflow based on a truthy value"
	'color': '#64adc9'
	'display_order': 450
	'size': {height: 60, width: 110}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'flags': []
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
			position: [0, 0.25, -1, 0]
		}
		{
			name: 'true'
			type: RoutineService.NODE_TYPE['Outflow'].value
			style: 'success'
			position: [1, 0.35, 1, 0]
			label: 'True'
			labelPosition: [-1, 0.5]
		}
		{
			name: 'false'
			type: RoutineService.NODE_TYPE['Outflow'].value
			style: 'error'
			position: [1, 0.65, 1, 0]
			label: 'False'
			labelPosition: [-1.1, 0.5]
		}
		{
			name: 'value'
			type: RoutineService.NODE_TYPE['Input'].value
			style: 'input'
			position: [0, 0.7, -1, 0]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service, service_inputs}) ->
		value = service_inputs['value']['value']

		if value
			return [{node: 'true'}]
		else
			return [{node: 'false'}]
