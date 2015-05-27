angular.module('app-factory').directive('afCanvasWidgetList', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-list.template.html'
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->

])