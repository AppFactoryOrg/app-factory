RoutineService.registerTemplate
	'name': 'math'
	'label': 'Math'
	'description': 'Evaluates a math expression'
	'color': '#837a9f'
	'size': {height: 70, width: 130}
	'type': RoutineService.SERVICE_TYPE['Data'].value
	'nodes': [
		{
			name: 'expression'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.55, -1, 0]
			label: 'Expression'
			labelPosition: [2.95, 0.5]
		}
		{
			name: 'variables'
			type: RoutineService.NODE_TYPE['Input'].value
			multiple: true
			position: [0, 0.77, -1, 0]
			label: 'Variables'
			labelPosition: [2.65, 0.5]
		}
		{
			name: 'result'
			type: RoutineService.NODE_TYPE['Output'].value
			multiple: true
			position: [1, 0.55, 1, 0]
			label: 'Result'
			labelPosition: [-1.2, 0.5]
		}
	]

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Math service does not have any inputs") unless service.inputs?
		throw new Meteor.Error('validation', "Math service does not have a 'expression' input") unless service.inputs.hasOwnProperty('expression')
		throw new Meteor.Error('validation', 'validation', "Math service does not have a 'variables' input") unless service.inputs.hasOwnProperty('variables')
		
		expression = service.inputs['expression']
		variables = service.inputs['variables']
		scope = {}
		variables.forEach (variable) ->
			name = variable['name']
			value = variable['value']
			throw new Error("Math service encountered a non-numeric variable.") unless _.isNumber(value)

			scope[name] = value

		value = math.eval(expression, scope)

		return [{node: 'result', value: value}]