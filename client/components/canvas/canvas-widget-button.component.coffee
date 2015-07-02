angular.module('app-factory').directive('afCanvasWidgetButton', ['$modal', 'ConfigureButtonWidgetModal', ($modal, ConfigureButtonWidgetModal) ->
	restrict: 'E'
	templateUrl: 'client/components/canvas/canvas-widget-button.template.html'
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->

		$scope.configureWidget = ->
			$modal.open(new ConfigureButtonWidgetModal($scope.widget)).result.then (parameters) ->
				$scope.widget['name'] = parameters['name']
				$scope.widget['configuration']['routine_id'] = parameters['routine_id']

])