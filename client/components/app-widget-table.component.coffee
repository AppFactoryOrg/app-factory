angular.module('app-factory').directive('afAppWidgetTable', ['$modal', '$meteor', ($modal, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/templates/app-widget-table.template.html'
	replace: true
	scope:
		'viewSchema': 	'='
		'widget': 		'='
		'parent':		'='
	controller: 'CommonAppWidgetCtrl'
	link: ($scope, $element) ->

		# Initialize
		data_source = $scope.widget['configuration']['data_source']
		switch data_source['type']
			when ViewWidget.DATA_SOURCE_TYPE['Document'].value
				document_schema_id = data_source['document_schema_id']
				$scope.documentSchema = DocumentSchema.db.findOne(document_schema_id)
])