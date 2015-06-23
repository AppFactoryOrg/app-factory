RoutineService.registerTemplate
	'name': 'lookup_document'
	'label': 'Lookup Document'
	'description': "Fetches a document from the database"
	'color': '#567CA0'
	'display_order': 50000
	'size': {height: 80, width: 150}
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
			position: [0, 0.6, -1, 0]
			label: 'Reference'
			labelPosition: [2.9, 0.55]
		}
		{
			name: 'error_not_found'
			type: RoutineService.NODE_TYPE['Error'].value
			multiple: true
			position: [1, 0.55, 1, 0]
			label: 'Not Found'
			labelPosition: [-1.85, 0.5]
		}
		{
			name: 'document'
			type: RoutineService.NODE_TYPE['Output'].value
			multiple: true
			position: [1, 0.77, 1, 0]
			label: 'Document'
			labelPosition: [-1.85, 0.5]
		}
	]

	describeConfiguration: (service) -> ""

	execute: ({service}) ->
		throw new Meteor.Error('validation', "Update Document service does not have any inputs") unless service.inputs?
		throw new Meteor.Error('validation', "Update Document service does not have a 'Reference' input") unless service.inputs.hasOwnProperty('reference')
		
		reference = service.inputs['reference']

		if _.isString(reference)
			document_id = reference
		else if reference.hasOwnProperty('_id')
			document_id = reference['_id']
		
		return [{node: 'error_not_found', value: "Reference is invalid"}] unless _.isString(document_id) and not _.isEmpty(document_id)
		
		document = Document.db.findOne(document_id)
		return [{node: 'error_not_found', value: "Document could not be found by the specified reference"}] unless document?
		
		return [
			{node: 'out'}
			{node: 'document', value: document}
		]