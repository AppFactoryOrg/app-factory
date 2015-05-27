angular.module('app-factory').directive('afAppView', ['$meteor', '$compile', ($meteor, $compile) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-view.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
	link: ($scope, $element) ->
		$scope.initializeRootWidgets = ->
			rootWidgetsEl = $('.root-widgets', $element)
			rootWidgetsEl.empty()
			$scope.viewSchema['$rootWidgets'].forEach (widget, index) ->
				index = $scope.viewSchema['$rootWidgets'].indexOf(widget) unless index?
				name = _.findWhere(ViewWidget.TYPE, 'value': widget['type']).component
				childTemplate = "
					<af-app-widget-#{name} 
						view-schema='viewSchema' 
						widget='viewSchema.$rootWidgets[#{index}]'>
					</af-app-widget-#{name}>
				"
				rootWidgetsEl = $('.root-widgets', $element)
				rootWidgetsEl.append(childTemplate)
				$compile(rootWidgetsEl)($scope)

		# Initialize
		$scope.initializeRootWidgets()
])