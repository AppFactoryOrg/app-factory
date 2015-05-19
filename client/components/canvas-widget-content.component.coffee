angular.module('app-factory').directive('afCanvasWidgetContent', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-content.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->

])