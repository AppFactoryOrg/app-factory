angular.module('app-factory').directive('afAppWidgetContent', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-content.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		$scope.contentHtml = $scope.widget['configuration']['content_html']
])	