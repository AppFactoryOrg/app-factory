angular.module('app-factory').directive('afCanvasWidgetButton', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-button.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->

])