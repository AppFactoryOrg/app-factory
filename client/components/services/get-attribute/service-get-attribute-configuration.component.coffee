angular.module('app-factory').directive('afServiceGetAttributeConfiguration', ['$compile', '$meteor', ($compile, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/services/get-attribute/service-get-attribute-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.documentSchemas = DocumentSchema.db.find().fetch()
		$scope.attributes = []
		$scope.selectedDocumentSchema = null

		$scope.documentTypeChanged = ->
			document_schema_id = $scope.service['configuration']['document_schema_id']
			if document_schema_id?
				$scope.selectedDocumentSchema = DocumentSchema.db.findOne(document_schema_id)
				$scope.attributes = _.filter($scope.selectedDocumentSchema.attributes, {'value_type': DocumentAttribute.VALUE_TYPE['Input'].value})
			else 
				$scope.selectedDocumentSchema = null
				$scope.attributes = null

		$scope.showAttributeSelection = ->
			return true if $scope.selectedDocumentSchema?
			return false

		# Initialize
		$scope.documentTypeChanged()
])