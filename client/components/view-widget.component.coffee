angular.module('app-factory').directive('afViewWidget', ['$meteor', '$compile', ($meteor, $compile) ->
	restrict: 'E'
	templateUrl: 'client/templates/view-widget.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
	link: ($scope, $element) ->
		unless _.isEmpty($scope.widget['$childWidgets'])
			childTemplate = '<af-view-widget ng-repeat="childWidget in widget.$childWidgets" view-schema="viewSchema" widget="childWidget"></af-view-widget>'
			$element.append(childTemplate)
			$compile($element.contents()[1])($scope)

	controller: ['$scope', ($scope) ->

	]
])