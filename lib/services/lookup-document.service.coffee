RoutineService.registerTemplate
	'name': 'lookup_document'
	'label': 'Lookup Document'
	'description': "Fetches a document from the database"
	'color': '#567CA0'
	'display_order': 50100
	'size': {height: 80, width: 150}
	'flags': ['accesses_db']
	'configuration':
		'name': ''
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
			name: 'reference'
			type: RoutineService.NODE_TYPE['Input'].value
			position: [0, 0.75, -1, 0]
			label: 'Reference'
			labelPosition: [2.9, 0.5]
		}
		{
			name: 'document'
			type: RoutineService.NODE_TYPE['Output'].value
			position: [1, 0.75, 1, 0]
			label: 'Document'
			labelPosition: [-1.85, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service, service_inputs}) ->
		throw new Meteor.Error('validation', "Lookup Document service does not have any inputs") unless service_inputs?

		reference = service_inputs['reference']?['value']

		if reference?
			if _.isString(reference)
				document_id = reference
			else if reference.hasOwnProperty('_id')
				document_id = reference['_id']

			if _.isString(document_id) and not _.isEmpty(document_id)
				document = Document.db.findOne(document_id)

		return [
			{node: 'out'}
			{
				node: 'document'
				output:
					value: document
					name: service['configuration']['name']
			}
		]
