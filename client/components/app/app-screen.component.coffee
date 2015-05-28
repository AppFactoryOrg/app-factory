angular.module('app-factory').directive('afAppScreen', ['$meteor', '$compile', ($meteor, $compile) ->
	restrict: 'E'
	templateUrl: 'client/components/app/app-screen.template.html'
	replace: true
	scope:
		'screenSchema': 	'='
	link: ($scope, $element) ->
		$scope.initializeRootWidgets = ->
			rootWidgetsEl = $('.root-widgets', $element)
			rootWidgetsEl.empty()
			$scope.screenSchema['$rootWidgets'].forEach (widget, index) ->
				index = $scope.screenSchema['$rootWidgets'].indexOf(widget) unless index?
				name = _.findWhere(ScreenWidget.TYPE, 'value': widget['type']).component
				childTemplate = "
					<af-app-widget-#{name} 
						screen-schema='screenSchema' 
						widget='screenSchema.$rootWidgets[#{index}]'>
					</af-app-widget-#{name}>
				"
				rootWidgetsEl = $('.root-widgets', $element)
				rootWidgetsEl.append(childTemplate)
				$compile(rootWidgetsEl)($scope)

		# Initialize
		$scope.initializeRootWidgets()
])