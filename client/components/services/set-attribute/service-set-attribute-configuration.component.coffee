angular.module('app-factory').directive('afServiceSetAttributeConfiguration', ['$compile', '$meteor', ($compile, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/services/set-attribute/service-set-attribute-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.documentSchemas = DocumentSchema.db.find().fetch()
		$scope.attributes = []
		$scope.selectedDocumentSchema = null

		$scope.documentTypeChanged = ->
			document_schema_id = $scope.service['configuration']['document_schema_id']
			unless _.isEmpty(document_schema_id)
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