class @ViewWidget

	@CONTAINER_LAYOUT =
		'Vertical': 	{value: 100}
		'Horizontal': 	{value: 200}

	@DATA_SOURCE_TYPE = 
		'Document':		{value: 100, default: {type: 100, 'document_schema_id': null}}

	@TYPE =
		'Container':
			value: 100
			component: 'container'
			icon: 'fa-th-large'
			configuration:
				'layout': @CONTAINER_LAYOUT['Vertical'].value

		'Table':
			value: 150
			component: 'table'
			icon: 'fa-table'
			configuration:
				'data_source': null

		'List':
			value: 200
			component: 'list'
			icon: 'fa-th-list'
			configuration:
				'data_source': null

		'Content':
			value: 250
			component: 'content'
			icon: 'fa-paragraph' 
			configuration:
				'content_html': null

		'View':
			value: 300
			component: 'view'
			icon: 'fa-list-alt'
			configuration:
				'view_schema_id': null

		'Button':
			value: 350
			component: 'button'
			icon: 'fa-caret-square-o-right'
			configuration:
				'routine_id': null

	constructor: (parameters) ->
		type = _.findWhere(ViewWidget.TYPE, 'value': parameters['type'])
		throw new Error('Unrecognized ViewWidget.TYPE specified') unless type?

		@id =				Meteor.uuid()
		@name =				parameters['name']
		@type =				type['value']
		@configuration =	_.clone(type['configuration'])
		@parent_id =		null
		@child_ids =		[]