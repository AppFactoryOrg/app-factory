angular.module('app-factory').directive('afCanvasWidgetContainer', ['$compile', '$modal', 'GenericModal', ($compile, $modal, GenericModal) ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-container.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonWidgetCtrl'
	link: ($scope, $element) ->
		$scope.appendChildWidget = (widget, index) ->
			index = $scope.widget['$childWidgets'].indexOf(widget) unless index?
			name = _.findWhere($scope.widgetTypes, 'value': widget['type']).name.toLowerCase()
			childTemplate = "
				<af-canvas-widget-#{name} 
					data-widget-id='#{widget.id}'
					view-schema='viewSchema' 
					edit-mode='editMode'
					widget='widget.$childWidgets[#{index}]'
					parent='widget'
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
						options: $scope.widgetTypes
						required: true
					}
				]
			)).result.then (parameters) ->
				widget = ViewWidget.new()
				widget['name'] = parameters['name']
				widget['type'] = parameters['type']
				widget['$childWidgets'] = []
				$scope.widget['$childWidgets'].push(widget)
				$scope.appendChildWidget(widget)

		$scope.initializeChildWidgets = ->
			return if _.isEmpty($scope.widget['$childWidgets'])
			$scope.widget['$childWidgets'].forEach (widget, index) -> $scope.appendChildWidget(widget, index)

		# Initialize
		$scope.initializeChildWidgets()
])