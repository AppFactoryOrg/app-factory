angular.module('app-factory').directive('afAppWidgetList', ['$modal', '$meteor', ($modal, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/app/app-widget-list.template.html'
	replace: true
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		
])