angular.module('app-factory').directive('afCanvasScreen', ['$meteor', '$compile', '$modal', 'GenericModal', ($meteor, $compile, $modal, GenericModal) ->
	restrict: 'E'
	templateUrl: 'client/components/canvas/canvas-screen.template.html'
	scope:
		'screenSchema': 	'='
		'editMode':		'='
	link: ($scope, $element) ->
		$scope.appendRootWidget = (widget, index) ->
			index = $scope.screenSchema['$rootWidgets'].indexOf(widget) unless index?
			name = _.findWhere(ScreenWidget.TYPE, 'value': widget['type']).component
			childTemplate = "
				<af-canvas-widget-#{name} 
					data-widget-id='#{widget.id}'
					screen-schema='screenSchema' 
					edit-mode='editMode'
					widget='screenSchema.$rootWidgets[#{index}]'>
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
						options: Utils.mapToArray(ScreenWidget.TYPE)
						required: true
					}
				]
			)).result.then (parameters) ->
				widget = ScreenWidget.new(parameters)
				widget['$childWidgets'] = []
				$scope.screenSchema['$rootWidgets'].push(widget)
				$scope.appendRootWidget(widget)

		$scope.initializeRootWidgets = ->
			rootWidgetsEl = $('.root-widgets', $element)
			rootWidgetsEl.empty()
			$scope.screenSchema['$rootWidgets'].forEach (widget, index) -> $scope.appendRootWidget(widget, index)

		# Initialize
		$scope.initializeRootWidgets()
		
		$scope.$watch('screenSchema', (oldSchema, newSchema) ->
			return unless oldSchema isnt newSchema
			$scope.initializeRootWidgets()
		)

		$scope.$on('CANVAS_WIDGET_DELETED', ->
			$scope.initializeRootWidgets()
		)
])