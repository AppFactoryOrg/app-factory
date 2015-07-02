angular.module('app-factory').directive('afServiceOutputConfiguration', ['$compile', '$meteor', ($compile, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/services/output/service-output-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.dataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
		$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find()

		$scope.typeUpdated = ->
			unless $scope.showDocumentSelection()
				$scope.service?['configuration']['document_schema_id'] = null
			
		$scope.showDocumentSelection =  ->
			switch $scope.service?['configuration']['data_type']
				when DocumentAttribute.DATA_TYPE['Document'].value
					return true
				when DocumentAttribute.DATA_TYPE['Collection'].value
					return true
				else
					return false
			
			return false
])