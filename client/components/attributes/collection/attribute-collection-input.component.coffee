angular.module('app-factory').directive('afAttributeCollectionInput', ['$modal', 'ViewCollectionModal', ($modal, ViewCollectionModal) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/collection/attribute-collection-input.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='	
	link: ($scope) ->

		# Initialize empty collection
		$scope.document.data[$scope.attribute['id']] = [] unless $scope.document.data[$scope.attribute['id']]?

		$scope.collection = $scope.document.data[$scope.attribute['id']]

		$scope.editCollection = ->
			documentSchemaId = $scope.attribute['configuration']['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			attribute = $scope.attribute
			collection = $scope.collection
			options =
				'edit': true
			$modal.open(new ViewCollectionModal({attribute, collection, documentSchema, options}))
])