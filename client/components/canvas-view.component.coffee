angular.module('app-factory').directive('afCanvasView', ['$meteor', '$compile', '$modal', 'GenericModal', ($meteor, $compile, $modal, GenericModal) ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-view.template.html'
	scope:
		'viewSchema': 	'='
		'editMode':		'='
	link: ($scope, $element) ->
		$scope.appendRootWidget = (widget, index) ->
			index = $scope.viewSchema['$rootWidgets'].indexOf(widget) unless index?
			name = _.findWhere(ViewWidget.TYPE, 'value': widget['type']).component
			childTemplate = "
				<af-canvas-widget-#{name} 
					data-widget-id='#{widget.id}'
					view-schema='viewSchema' 
					edit-mode='editMode'
					widget='viewSchema.$rootWidgets[#{index}]'
				</af-canvas-widget-#{name}>
			"
			rootWidgetsEl = $('.root-widgets', $element)
			rootWidgetsEl.append(childTemplate)
			$compile(rootWidgetsEl)($scope)

		$scope.createRootWidget = ->
			$modal.open(new GenericModal(
				title: 'Add Widget'
				submitAction: 'Add'
				attributes: [
					{
						name: 'name'
						displayAs: 'Name'
						required: true
						autofocus: true
					}
					{
						name: 'type'
						displayAs: 'Type'
						type: 'select'
						options: Utils.mapToArray(ViewWidget.TYPE)
						required: true
					}
				]
			)).result.then (parameters) ->
				widget = ViewWidget.new(parameters)
				widget['$childWidgets'] = []
				$scope.viewSchema['$rootWidgets'].push(widget)
				$scope.appendRootWidget(widget)

		$scope.initializeRootWidgets = ->
			rootWidgetsEl = $('.root-widgets', $element)
			rootWidgetsEl.empty()
			$scope.viewSchema['$rootWidgets'].forEach (widget, index) -> $scope.appendRootWidget(widget, index)

		# Initialize
		$scope.initializeRootWidgets()
		
		$scope.$watch('viewSchema', (oldSchema, newSchema) ->
			return unless oldSchema isnt newSchema
			$scope.initializeRootWidgets()
		)

		$scope.$on('CANVAS_WIDGET_DELETED', ->
			$scope.initializeRootWidgets()
		)
])