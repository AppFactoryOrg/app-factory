angular.module('app-factory').directive('afCanvasWidgetTable', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-table.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonWidgetCtrl'
	link: ($scope, $element) ->

])