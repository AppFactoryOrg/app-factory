angular.module('app-factory').directive('afAppWidgetButton', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-button.template.html'
	replace: true
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		
])