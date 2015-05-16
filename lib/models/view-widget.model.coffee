class @ViewWidget

	@CONTAINER_LAYOUT =
		'Vertical': 	{value: 100}
		'Horizontal': 	{value: 200}

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
			configuration: {}

		'List':
			value: 200
			component: 'list'
			icon: 'fa-th-list'
			configuration: {}

		'Content':
			value: 250
			component: 'content'
			icon: 'fa-paragraph' 
			configuration: {}

		'View':
			value: 300
			component: 'view'
			icon: 'fa-list-alt'
			configuration: {}

		'Button':
			value: 350
			component: 'button'
			icon: 'fa-caret-square-o-right'
			configuration: {}

	constructor: (parameters) ->
		type = _.findWhere(ViewWidget.TYPE, 'value': parameters['type'])
		throw new Error('Unrecognized ViewWidget.TYPE specified') unless type?

		@id =				Meteor.uuid()
		@name =				parameters['name']
		@type =				type['value']
		@configuration =	_.clone(type['configuration'])
		@parent_id =		null
		@child_ids =		[]