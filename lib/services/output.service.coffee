RoutineService.registerTemplate
	'name': 'output'
	'label': 'Output'
	'description': "The output values for the routine"
	'color': '#df706c'
	'display_order': 400
	'size': {height: 56, width: 110}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'flags': []
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
			position: [0, 0.3, -1, 0]
		}
		{
			name: 'values'
			type: RoutineService.NODE_TYPE['Input'].value
			style: 'input-multiple'
			multiple: true
			position: [0, 0.7, -1, 0]
			label: 'Values'
			labelPosition: [2.4, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Output service does not have any inputs") unless service_inputs?

		outputs = service_inputs['values']
		service['outputs'] = outputs

		return []
