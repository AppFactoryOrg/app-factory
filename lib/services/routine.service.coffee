RoutineService.registerTemplate
	'name': 'routine'
	'label': 'Routine'
	'description': "Executes a routine"
	'color': '#567CA0'
	'display_order': 50000
	'size': {height: 80, width: 150}
	'flags': ['accesses_db']
	'configuration':
		'routine_id': null
	'nodes': [
		{
			name: 'in'
			type: RoutineService.NODE_TYPE['Inflow'].value
			position: [0, 0.25, -1, 0]
		}
		{
			name: 'out'
			type: RoutineService.NODE_TYPE['Outflow'].value
			position: [1, 0.25, 1, 0]
		}
		{
			name: 'inputs'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.75, -1, 0]
			label: 'Inputs'
			labelPosition: [2.4, 0.5]
		}
		{
			name: 'outputs'
			type: RoutineService.NODE_TYPE['Output'].value
			position: [1, 0.75, 1, 0]
			label: 'Outputs'
			labelPosition: [-1.65, 0.5]
		}
	]

	describeConfiguration: (service) ->
		routine_id = service['configuration']['routine_id']
		return "" unless routine_id?
		routine = Routine.db.findOne(routine_id)
		return "" unless routine?
		return routine.name

	execute: ({service, service_inputs, environment_id}) ->
		throw new Meteor.Error('validation', "Routine service does not have any inputs") unless service_inputs?
		throw new Meteor.Error('validation', "Routine service does not specify a routine") unless service['configuration']['routine_id']?

		routine_id = service['configuration']['routine_id']
		routine = Routine.db.findOne(routine_id)
		throw new Meteor.Error('data', "Routine cannot be found") unless routine?

		outputs = Routine.execute(routine_id, service_inputs, environment_id)

		return [
			{node: 'out'}
			{
				node: 'outputs'
				output: outputs
			}
		]
