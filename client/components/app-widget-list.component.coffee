angular.module('app-factory').directive('afAppWidgetList', ['$modal', '$meteor', ($modal, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-list.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		
])