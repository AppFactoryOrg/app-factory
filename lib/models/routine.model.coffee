@Routine =

	db: new Mongo.Collection('routines')

	MUTABLE_PROPERTIES: [
		'name'
		'type'
		'description'
		'size'
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
			log: (message, artifact) ->
				date = Date.now()
				@records.push({message, artifact, date})
				# console.log("#{date} | Routine #{@routine._id} | #{message}", artifact)
		}

	execute: (routine_id, routine_inputs, environment_id) ->
		routine = Routine.db.findOne(routine_id)
		throw new Error('Cannot find specified routine.') unless routine?

		logger = Routine.makeLogger(routine)
		logger.log("Starting execution of routine", routine)

		services = _.clone(routine['services'])
		throw new Error('Routine has no services.') unless services.length > 0

		connections = _.clone(routine['connections'])
		throw new Error('Routine has no connections.') unless connections.length > 0

		# Prep services for execution
		services.forEach (service) ->
			service['outputs'] = {}
			service['has_executed'] = false
			service['template'] = _.find(RoutineService.service_templates, {'name': service['name']})

		resolveInputs = (service) ->
			inputs = {}

			input_nodes = _.filter(service['template']['nodes'], {'type': RoutineService.NODE_TYPE['Input'].value})
			input_nodes.forEach (input_node) ->
				logger.log("Resolving service input dependency '#{input_node.name}'", service)

				input_connections = _.filter(connections, {'toNode': "#{service.id}_#{input_node.name}"})
				throw new Error('Routine cannot find input connections.') unless input_connections?

				input_connections.forEach (connection) ->
					connection_service_id = connection['fromNode'].split('_')[0]
					input_service = _.find(services, {'id': connection_service_id})
					throw new Error('Routine cannot find input dependency service.') unless input_service?

					connection_node_name = connection['fromNode'].split('_')[1]
					input_service_output_node = _.find(input_service['template']['nodes'], {'name': connection_node_name})
					throw new Error('Routine cannot find input dependency node.') unless input_service_output_node?

					if input_service['has_executed'] is false
						processService(input_service)

					output_value = input_service['outputs'][input_service_output_node['name']]
					throw new Error('Routine cannot find input dependency value.') if _.isUndefined(output_value)

					if input_node['multiple'] is true
						inputs[input_node['name']] = [] unless _.isArray(inputs[input_node['name']])
						inputs[input_node['name']].push(output_value)
					else
						inputs[input_node['name']] = output_value

			return inputs

		stack_counter = 0
		processService = (service) ->
			logger.log("Starting processing of service", service)

			# Prevent infinite loops
			stack_counter++
			throw new Error('Routine got stuck in a potentially infinite loop.') if stack_counter > 10000

			# Resolve input dependencies and execute
			service_inputs = resolveInputs(service)
			results = service['template'].execute({service, service_inputs, routine_inputs, environment_id})
			throw new Error('Routine service execution results were invalid.') unless results?

			# Record outputs
			service['has_executed'] = true
			output_nodes = _.filter(service['template']['nodes'], {'type': RoutineService.NODE_TYPE['Output'].value})
			output_nodes.forEach (output_node) ->
				node_name = output_node['name']
				result = _.find(results, {'node': node_name})
				throw new Error('Routine cannot find matching result for output node.') unless result?

				service['outputs'][node_name] = result['output']

			logger.log("Ending processing of service", service)

			# Process service outflows
			results.forEach (result) ->
				result_node = _.find(service['template']['nodes'], {'name': result['node']})
				throw new Error('Routine cannot find result node in service.') unless result_node?

				if result_node['type'] is RoutineService.NODE_TYPE['Outflow'].value
					output_connection = _.find(connections, {'fromNode': "#{service.id}_#{result_node.name}"})
					return unless output_connection?

					output_service = _.find(services, {'id': output_connection['toNode'].split('_')[0]})
					throw new Error('Routine cannot find output service.') unless output_service?

					processService(output_service)

		# Start executing the workflow, if applicable
		start = _.findWhere(services, {'name': 'start'})
		processService(start) if start?

		# Resolve output data
		output_service = _.findWhere(services, {'name': 'output', 'has_executed': true})
		if output_service?
			output_data = output_service['outputs']
		else
			output_data = []

		logger.log("Ending processing of routine", routine)

		return output_data
