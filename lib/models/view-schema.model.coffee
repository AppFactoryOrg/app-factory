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
		viewSchema['$rootWidgets'] = _.filter(viewSchema['widgets'], 'parent_id': null)

		buildHierarchy = (widget) ->
			widget['$childWidgets'] = []
			widget['child_ids'].forEach (child_id) ->
				child = _.findWhere(viewSchema['widgets'], 'id': child_id)
				throw new Error('ViewSchema.buildWidgetHierarchy could not find child widget by id') unless child?
				widget['$childWidgets'].push(child)
				buildHierarchy(child)

		viewSchema['$rootWidgets'].forEach (widget) -> buildHierarchy(widget)

		return viewSchema

	bakeWidgetHierarchy: (viewSchema) ->
		viewSchema = angular.copy(viewSchema)

		allWidgets = []
		collectWidgets = (widget) ->
			widget['$childWidgets'].forEach (child) ->
				allWidgets.push(child)
				collectWidgets(child)

		viewSchema['$rootWidgets'].forEach (widget) -> 
			allWidgets.push(widget)
			collectWidgets(widget)
		
		viewSchema['widgets'] = allWidgets
		viewSchema['widgets'].forEach (widget) ->
			widget['child_ids'] = _.pluck(widget['$childWidgets'], 'id')
			widget['$childWidgets'].forEach (childWidget) -> childWidget['parent_id'] = widget['id']
			
		viewSchema['widgets'].forEach (widget) -> delete widget['$childWidgets']
		delete viewSchema['$rootWidgets']

		return viewSchema
