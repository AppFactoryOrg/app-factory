angular.module('app-factory').directive('afCanvasWidgetTable', ['$modal', 'ConfigureTableWidgetModal', ($modal, ConfigureTableWidgetModal) ->
	restrict: 'E'
	templateUrl: 'client/templates/canvas-widget-table.template.html'
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonWidgetCtrl'
	link: ($scope, $element) ->
		$scope.configureWidget = ->
			$modal.open(new ConfigureTableWidgetModal($scope.widget)).result.then (parameters) ->
				$scope.widget['name'] = parameters['name']
				$scope.widget['configuration']['data_source'] = parameters['data_source']

])