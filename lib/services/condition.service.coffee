RoutineService.registerTemplate
	'name': 'condition'
	'label': 'Condition'
	'description': "Checks the specified condition against multiple inputs"
	'color': '#64adc9'
	'display_order': 480
	'size': {height: 50, width: 110}
	'type': RoutineService.SERVICE_TYPE['Logic'].value
	'flags': []
	'configuration':
		'operator': null
	'meta_data':
		'operators': {'all true', 'all false', 'any true', 'any false'}
	'nodes': [
		{
			name: 'inputs'
			style: 'input-multiple'
			multiple: true
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.5, -1, 0]
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
		throw new Meteor.Error('validation', "Check service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Check service does not have any inputs") unless service_inputs['inputs']?
		throw new Meteor.Error('validation', "Check service does not have an operator configured") unless service['configuration']['operator']?

		values = _.pluck(service_inputs['inputs'], 'value')
		operator = service['configuration']['operator']

		if operator is 'all true'
			result = _.all(values, (value) -> value is true)
		else if operator is 'all false'
			result = _.all(values, (value) -> value is false)
		else if operator is 'any true'
			result = _.some(values, (value) -> value is true)
		else if operator is 'any false'
			result = _.some(values, (value) -> value is false)
		else
			result = false

		return [{
			node: 'result'
			output:
				value: result
		}]
