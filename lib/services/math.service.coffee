RoutineService.registerTemplate
	'name': 'math'
	'label': 'Math'
	'description': 'Evaluates a math expression'
	'color': '#837a9f'
	'display_order': 10000
	'size': {height: 50, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'flags': []
	'configuration':
		'name': ''
		'expression': ''
	'nodes': [
		{
			name: 'variables'
			type: RoutineService.NODE_TYPE['Input'].value
			style: 'input-multiple'
			multiple: true
			position: 'Left'
		}
		{
			name: 'result'
			type: RoutineService.NODE_TYPE['Output'].value
			position: 'Right'
		}
	]

	describeConfiguration: (service) ->
		return unless service?
		expression = service['configuration']['expression']
		return "#{expression}"

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Math service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Math service does not have a 'variables' input") unless service_inputs['variables']?

		scope = {}
		expression = service['configuration']['expression']
		variables = service_inputs['variables']

		try
			variables.forEach (variable) ->
				name = variable['name']
				value = variable['value']
				return unless _.isNumber(value)
				scope[name] = value

			value = math.eval(expression, scope)
			value = math.format(value, {precision: 14})
			value = parseFloat(value)
		catch error
			console.log("Math service encounted error: #{error.stack}")

		value = value ? null

		return [{
			node: 'result'
			output:
				value: value
				name: service['configuration']['name']
		}]
