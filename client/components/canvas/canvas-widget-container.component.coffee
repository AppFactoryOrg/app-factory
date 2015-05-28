angular.module('app-factory').directive('afCanvasWidgetContainer', ['$compile', '$modal', 'GenericModal', ($compile, $modal, GenericModal) ->
	restrict: 'E'
	templateUrl: 'client/components/canvas/canvas-widget-container.template.html'
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->
		$scope.containerLayouts = Utils.mapToArray(ScreenWidget.CONTAINER_LAYOUT)

		$scope.appendChildWidget = (widget, index) ->
			index = $scope.widget['$childWidgets'].indexOf(widget) unless index?
			name = _.findWhere(ScreenWidget.TYPE, 'value': widget['type']).component
			childTemplate = "
				<af-canvas-widget-#{name} 
					data-widget-id='#{widget.id}'
					screen-schema='screenSchema' 
					edit-mode='editMode'
					widget='widget.$childWidgets[#{index}]'
					parent='widget'>
				</af-canvas-widget-#{name}>
			"
			childWidgetsEl = $('.child-widgets', $element)
			childWidgetsEl.append(childTemplate)
			$compile(childWidgetsEl)($scope)

		$scope.createChildWidget = ->
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
				$scope.widget['$childWidgets'].push(widget)
				$scope.appendChildWidget(widget)

		$scope.initializeChildWidgets = ->
			return if _.isEmpty($scope.widget['$childWidgets'])
			$scope.widget['$childWidgets'].forEach (widget, index) -> $scope.appendChildWidget(widget, index)

		$scope.configureWidget = ->
			$modal.open(new GenericModal(
				title: 'Configure Container'
				submitAction: 'Save'
				attributes: [
					{
						name: 'name'
						displayAs: 'Name'
						required: true
						autofocus: true
						default: $scope.widget['name']
					}
					{
						name: 'layout'
						displayAs: 'Layout'
						type: 'select'
						options: Utils.mapToArray(ScreenWidget.CONTAINER_LAYOUT)
						required: true
						default: $scope.widget['configuration']['layout']
					}
				]
			)).result.then (parameters) ->
				$scope.widget['name'] = parameters['name']
				$scope.widget['configuration']['layout'] = parameters['layout']

		# Initialize
		$scope.initializeChildWidgets()
])