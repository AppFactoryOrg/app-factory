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
		throw new Error('Routine has no services.') unless services.length

		connections = _.clone(routine['connections'])
		throw new Error('Routine has no connections.') unless connections.length

		stack_counter = 0
		processService = (service) ->
			logger.log("Starting processing of service", service)

			# Prevent infinite loops
			stack_counter++
			throw new Error('Routine got stuck in a potentially infinite loop.') if stack_counter > 10000
			
			# Check for inputs and execute them first
			input_nodes = _.filter(service.nodes, {'type': 'input'})
			input_nodes.forEach (input_node) ->
				input_connections = _.filter(connections, {'toNode': "#{service.id}_#{input_node.name}"})
				throw new Error('Routine cannot find input connections.') unless input_connections?

				input_connections.forEach (inputConnection) ->
					inputService = _.find(services, {'id': inputConnection['fromNode'].split('_')[0]})
					throw new Error('Routine cannot find input service.') unless inputService?

					processService(inputService)

			# Lookup the service template, which contains the execute function
			service_template = _.find(RoutineService.service_templates, {'name': service['name']})
			throw new Error('Routine cannot find matching service template.') unless service_template?

			# Execute the service
			results = service_template.execute({service, routine_inputs})
			throw new Error('Routine service execution results were empty.') if _.isEmpty(results)

			logger.log("Ending processing of service", service)
			
			results.forEach (result) ->
				# Process result node
				result_node = _.find(service['nodes'], {'name': result['node']})
				throw new Error('Routine cannot find result node in service.') unless result_node?
				
				if result_node['type'] is RoutineService.NODE_TYPE['Output'].value
					# Pass output value to next services
					output_connections = _.filter(connections, {'fromNode': "#{service.id}_#{result_node.name}"})
					throw new Error('Routine cannot find output connections.') unless output_connections?

					output_connections.forEach (output_connection) ->
						output_service = _.find(services, {'id': output_connection['toNode'].split('_')[0]})
						throw new Error('Routine cannot find output service.') unless output_service?

						input_node = _.find(output_service.nodes, {name: output_connection['toNode'].split('_')[1]})
						throw new Error('Routine cannot find input node of output service.') unless input_node?
						
						output_service.inputs = [] unless output_service.inputs?
						if input_node['multiple'] is true
							output_service.inputs[input_node['name']] = [] unless _.isArray(output_service.inputs[input_node['name']])
							output_service.inputs[input_node['name']].push(result['value'])
						else
							output_service.inputs[input_node['name']] = result['value']

				else if result_node['type'] in [RoutineService.NODE_TYPE['Output'].value, RoutineService.NODE_TYPE['Error'].value]
					# Pass flow to next service
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
