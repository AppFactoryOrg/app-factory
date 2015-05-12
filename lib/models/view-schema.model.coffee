@ViewSchema = 

	db: new Mongo.Collection('view-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'widgets'
	]

	new: ->
		'name': 			null
		'description':		null
		'widgets':			[]
		'blueprint_id': 	null

	buildWidgetHierarchy: (viewSchema) ->
		buildHierarchy = (parent) ->
			children = _.filter(viewSchema['widgets'], 'parent_id': parent['id'])
			parent['_children'] = children
			children.forEach (child) ->
				buildHierarchy(child)

		rootWidgets = _.filter(viewSchema['widgets'], 'parent_id': null)
		rootWidgets.forEach (widget) -> buildHierarchy(widget)
