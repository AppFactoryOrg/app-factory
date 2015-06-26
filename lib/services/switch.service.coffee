RoutineService.registerTemplate
	'name': 'switch'
	'label': 'Switch'
	'description': "Directs the workflow based on a logical expression"
	'color': '#64adc9'
	'display_order': 450
	'size': {height: 80, width: 110}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'configuration':
		'name': ''
		'expression': null
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
			position: [1, 0.5, 1, 0]
			label: 'True'
			labelPosition: [-1, 0.5]
		}
		{
			name: 'false'
			type: RoutineService.NODE_TYPE['Outflow'].value
			style: 'error'
			position: [1, 0.75, 1, 0]
			label: 'False'
			labelPosition: [-1.1, 0.5]
		}
		{
			name: 'variables'
			type: RoutineService.NODE_TYPE['Input'].value
			style: 'input-multiple'
			multiple: true
			position: [0, 0.75, -1, 0]
			label: 'Variables'
			labelPosition: [2.75, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Value service does not have a configuration") unless service['configuration']?

		result = false

		if result is true
			return [{node: 'true'}]
		else
			return [{node: 'false'}]
