@ScreenSchema = 

	db: new Mongo.Collection('screen-schema')

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

	buildWidgetHierarchy: (screenSchema) ->
		screenSchema['$rootWidgets'] = _.filter(screenSchema['widgets'], 'parent_id': null)

		buildHierarchy = (widget) ->
			widget['$childWidgets'] = []
			widget['child_ids'].forEach (child_id) ->
				child = _.findWhere(screenSchema['widgets'], 'id': child_id)
				throw new Error('ScreenSchema.buildWidgetHierarchy could not find child widget by id') unless child?
				widget['$childWidgets'].push(child)
				buildHierarchy(child)

		screenSchema['$rootWidgets'].forEach (widget) -> buildHierarchy(widget)

		return screenSchema

	bakeWidgetHierarchy: (screenSchema) ->
		screenSchema = angular.copy(screenSchema)

		allWidgets = []
		collectWidgets = (widget) ->
			widget['$childWidgets'].forEach (child) ->
				allWidgets.push(child)
				collectWidgets(child)

		screenSchema['$rootWidgets'].forEach (widget) -> 
			allWidgets.push(widget)
			collectWidgets(widget)
		
		screenSchema['widgets'] = allWidgets
		screenSchema['widgets'].forEach (widget) ->
			widget['child_ids'] = _.pluck(widget['$childWidgets'], 'id')
			widget['$childWidgets'].forEach (childWidget) -> childWidget['parent_id'] = widget['id']
			
		screenSchema['widgets'].forEach (widget) -> delete widget['$childWidgets']
		delete screenSchema['$rootWidgets']

		return screenSchema
