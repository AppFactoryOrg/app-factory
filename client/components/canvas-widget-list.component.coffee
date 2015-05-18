angular.module('app-factory').directive('afCanvasWidgetList', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-list.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonWidgetCtrl'
	link: ($scope, $element) ->

])