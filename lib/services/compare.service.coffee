RoutineService.registerTemplate
	'name': 'compare'
	'label': 'Compare'
	'description': "Compares two inputs based on an operator"
	'color': '#64adc9'
	'display_order': 460
	'size': {height: 60, width: 110}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'flags': []
	'configuration':
		'data_type': null
		'operator': null
	'nodes': [
		{
			name: 'A'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.5, -1, 0]
			label: 'A'
			labelPosition: [1.4, 0.5]
		}
		{
			name: 'B'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.75, -1, 0]
			label: 'B'
			labelPosition: [1.4, 0.5]
		}
		{
			name: 'result'
			type: RoutineService.NODE_TYPE['Output'].value
			position: [1, 0.5, 1, 0]
		}
	]

	describeConfiguration: (service) ->
		return service['configuration']['operator']

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Compare service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Compare service does not have a 'A' input") unless service_inputs['A']?
		throw new Meteor.Error('validation', "Compare service does not have a 'B' input") unless service_inputs['B']?

		value_a = service_inputs['A']['value']
		value_b = service_inputs['B']['value']
		data_type = service['configuration']['data_type']
		operator = service['configuration']['operator']

		result = DocumentAttribute.compare({value_a, value_b, data_type, operator})

		return [{
			node: 'result'
			output:
				value: result
		}]
