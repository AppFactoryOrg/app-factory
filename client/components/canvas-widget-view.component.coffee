angular.module('app-factory').directive('afCanvasWidgetView', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-view.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonWidgetCtrl'
	link: ($scope, $element) ->

])