angular.module('app-factory').directive('afAppWidgetContainer', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-container.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		$scope.containerLayouts = Utils.mapToArray(ViewWidget.CONTAINER_LAYOUT)

		$scope.initializeChildWidgets = ->
			return if _.isEmpty($scope.widget['$childWidgets'])
			$scope.widget['$childWidgets'].forEach (widget, index) ->
				index = $scope.widget['$childWidgets'].indexOf(widget) unless index?
				name = _.findWhere(ViewWidget.TYPE, 'value': widget['type']).component
				childTemplate = "
					<af-app-widget-#{name} 
						view-schema='viewSchema' 
						widget='widget.$childWidgets[#{index}]'
						parent='widget'>
					</af-app-widget-#{name}>
				"
				childWidgetsEl = $('.child-widgets', $element)
				childWidgetsEl.append(childTemplate)
				$compile(childWidgetsEl)($scope)

		# Initialize
		$scope.initializeChildWidgets()
])