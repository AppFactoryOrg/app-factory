RoutineService.registerTemplate
	'name': 'math'
	'label': 'Math'
	'description': 'Evaluates a math expression'
	'color': '#837a9f'
	'display_order': 10000
	'size': {height: 70, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'flags': []
	'nodes': [
		{
			name: 'expression'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.5, -1, 0]
			label: 'Expression'
			labelPosition: [2.95, 0.5]
		}
		{
			name: 'variables'
			type: RoutineService.NODE_TYPE['Input'].value
			multiple: true
			position: [0, 0.75, -1, 0]
			label: 'Variables'
			labelPosition: [2.65, 0.5]
		}
		{
			name: 'result'
			type: RoutineService.NODE_TYPE['Output'].value
			position: [1, 0.5, 1, 0]
			label: 'Result'
			labelPosition: [-1.2, 0.5]
		}
	]

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Math service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Math service does not have a 'expression' input") unless service_inputs['expression']?
		throw new Meteor.Error('validation', 'validation', "Math service does not have a 'variables' input") unless service_inputs['variables']?
		
		scope = {}
		expression = service_inputs['expression']
		variables = service_inputs['variables']
		variables.forEach (variable) ->
			name = variable['name']
			value = variable['value']
			return unless _.isNumber(value)

			scope[name] = value

		try 
			value = math.eval(expression, scope)
			value = math.format(value, {precision: 14})
			value = parseFloat(value)
		catch error
			console.log("Math service encounted error: #{error}")

		return [{node: 'result', value: value ? null}]