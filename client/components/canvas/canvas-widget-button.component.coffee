angular.module('app-factory').directive('afCanvasWidgetButton', [() ->
	restrict: 'E'
	templateUrl: 'client/components/canvas/canvas-widget-button.template.html'
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->

])