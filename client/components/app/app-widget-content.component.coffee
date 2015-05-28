angular.module('app-factory').directive('afAppWidgetContent', [() ->
	restrict: 'E'
	templateUrl: 'client/components/app/app-widget-content.template.html'
	replace: true
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		$scope.contentHtml = $scope.widget['configuration']['content_html']
])	