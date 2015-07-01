angular.module('app-factory').directive('afCanvasWidgetTable', ['$modal', 'ConfigureTableWidgetModal', ($modal, ConfigureTableWidgetModal) ->
	restrict: 'E'
	templateUrl: 'client/components/canvas/canvas-widget-table.template.html'
	scope:
		'screenSchema': 	'='
		'widget': 		'='
		'parent':		'='
		'editMode': 	'='
	controller: 'CommonCanvasWidgetCtrl'
	link: ($scope, $element) ->
		$scope.configureWidget = ->
			$modal.open(new ConfigureTableWidgetModal($scope.widget)).result.then (parameters) ->
				$scope.widget['name'] = parameters['name']
				$scope.widget['configuration']['data_source'] = parameters['data_source']

		$scope.getDataSourceName = ->
			dataSource = $scope.widget['configuration']['data_source']
			switch dataSource?['type']
				when ScreenWidget.DATA_SOURCE_TYPE['Database'].value
					documentSchema = DocumentSchema.db.findOne(dataSource['document_schema_id'])
					if documentSchema?
						name = "Database - #{documentSchema?.name}"
				when ScreenWidget.DATA_SOURCE_TYPE['Fixed'].value
					documentSchema = DocumentSchema.db.findOne(dataSource['document_schema_id'])
					name = "Fixed - #{documentSchema?.name}"

			return name
])
