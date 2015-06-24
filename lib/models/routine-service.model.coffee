@RoutineService =

	SERVICE_TYPE: 
		'Logic':	 	{value: 'logic', name: 'Logic'}
		'Workflow': 	{value: 'workflow', name: 'Workflow'}
		'Data': 		{value: 'data', name: 'Data'}

	NODE_TYPE:
		'Inflow':		{value: 'inflow'}
		'Outflow':		{value: 'outflow'}
		'Input':		{value: 'input'}
		'Output':		{value: 'output'}
		'Error':		{value: 'error'}

	new: (parameters) ->
		'id': Meteor.uuid()
		'name': parameters['name']
		'position': parameters['position']
		'configuration': parameters['configuration']

	service_templates: []
	registerTemplate: (template) ->
		@service_templates.push(template)

	getServicesTemplatesForRoutine: (routine) ->
		switch routine['type']
			when Routine.TYPE['Attribute'].value
				templates = _.filter(RoutineService.service_templates, (template) ->
					return false if _.contains(template['flags'], 'modifies_db')
					return true
				)
				console.log templates
				return templates
			else
				return RoutineService.service_templates

