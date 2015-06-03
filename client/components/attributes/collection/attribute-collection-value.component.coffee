angular.module('app-factory').directive('afAttributeCollectionValue', ['$modal', 'ViewCollectionModal', ($modal, ViewCollectionModal) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/collection/attribute-collection-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->

		$scope.collection = $scope.document['data'][$scope.attribute['id']]

		$scope.viewCollection = ->
			documentSchemaId = $scope.attribute['configuration']['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			attribute = $scope.attribute
			collection = $scope.collection
			$modal.open(new ViewCollectionModal({attribute, collection, documentSchema}))

])