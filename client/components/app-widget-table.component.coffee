angular.module('app-factory').directive('afAppWidgetTable', ['$modal', '$meteor', ($modal, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-table.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->
		
])