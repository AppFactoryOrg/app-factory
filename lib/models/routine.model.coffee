@Routine =
	
	db: new Mongo.Collection('routines')
	
	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'size',
		'services'
		'connections'
	]

	TYPE:
		'General':		{value: 100}
		'Attribute':	{value: 200}
		'Action':		{value: 300}

	new: (parameters) ->
		'name':				parameters['name']
		'description':		parameters['description']
		'size':				{'height': 2000, 'width': 3000}
		'type':				parameters['type']
		'services':			[]
		'connections':		[]
		'blueprint_id':		parameters['blueprint_id']

	makeLogger: (routine) ->
		return {
			routine: routine
			records: []
			log: (info, artifact) ->
				console.debug(info)
				date = Date.now()
				records.push({info, artifact, date})
		}

	execute: (routineId, routine_inputs) ->
		routine = Routines.findOne(routineId)
		throw new Error('Cannot find specified routine.') unless routine?

		logger = Routine.makeLogger(routine)
		logger.log("Starting execution of routine", routine_inputs)

		services = _.clone(routine['services'])
		throw new Error('Routine has no services.') unless services.length > 0

		connections = _.clone(routine['connections'])
		throw new Error('Routine has no connections.') unless connections.length > 0

		# Prep services for execution
		services.forEach (service) -> 
			service['outputs'] = {}
			service['has_executed'] = false
			service['template'] = _.find(RoutineService.service_templates, {'name': service['name']})

		stack_counter = 0

		processService = (service) ->
			logger.log("Starting processing of service", service)

			# Prevent infinite loops
			stack_counter++
			throw new Error('Routine got stuck in a potentially infinite loop.') if stack_counter > 10000

			# Resolve input dependencies
			service_inputs = {}
			input_nodes = _.filter(service['nodes'], {'type': RoutineService.NODE_TYPE['Input'].value})
			input_nodes.forEach (input_node) ->
				logger.log("Resolving service input dependency '#{input_node.name}'", service)
				
				input_connections = _.filter(connections, {'toNode': "#{service.id}_#{input_node.name}"})
				throw new Error('Routine cannot find input connections.') unless input_connections?

				input_connections.forEach (connection) ->
					input_service = _.find(services, {'id': connection['fromNode'].split('_')[0]})
					throw new Error('Routine cannot find input dependency service.') unless input_service?

					if input_service['has_executed'] = false
						processService(input_service)

					input_service_output_node = _.find(services, {'id': connection['fromNode'].split('_')[1]})
					output_value = _.find(input_service['outputs'], {'name': input_service_output_node['name']}
					throw new Error('Routine cannot find input dependency value.') unless output_value?

					service_inputs[input_node['name']] = output_value

			# Execute the service
			results = service['template'].execute({service, service_inputs, routine_inputs})
			throw new Error('Routine service execution results were empty.') if _.isEmpty(results)

			# Record outputs
			service['has_executed'] = true
			output_nodes = _.filter(service['nodes'], {'type': RoutineService.NODE_TYPE['Output'].value})
			output_nodes.forEach (output_node) ->
				service['outputs'][output_node['name']] = output_node['value']

			logger.log("Ending processing of service", service)
			
			# Process service outflows
			results.forEach (result) ->
				result_node = _.find(service['nodes'], {'name': result['node']})
				throw new Error('Routine cannot find result node in service.') unless result_node?

				if result_node['type'] in [RoutineService.NODE_TYPE['Output'].value, RoutineService.NODE_TYPE['Error'].value]
					output_connection = _.find(connections, {'fromNode': "#{service.id}_#{result_node.name}"})
					throw new Error('Routine cannot find output connection.') unless output_connection?

					output_service = _.find(services, {'id': output_connection['toNode'].split('_')[0]})
					throw new Error('Routine cannot find output service.') unless output_service?

					processService(output_service)

		# Kick it off
		start = _.findWhere(services, {'name': 'start'})
		throw new Error('Routine has no Start service.') unless start?

		processService(start)

		# Get output data
		output_data = []
		output_services = _.filter(services, {'name': 'output'})
		output_services.forEach (output_service) ->
			output =
				name: output_service['configuration']['name']
				type: output_service['configuration']['type']
				value: output_service['inputs']['value']

			output_data.push(output)

		return output_data
