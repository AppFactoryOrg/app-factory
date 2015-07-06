angular.module('app-factory').directive('afAttributeCollectionValue', ['$modal', 'ViewCollectionModal', ($modal, ViewCollectionModal) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/collection/attribute-collection-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.$on 'ATTRIBUTE_VALUE', (e, collection) ->
			if collection?
				$scope.hasCollection = true
				$scope.collection = collection
			else
				$scope.hasCollection = false
				$scope.collection = null

		$scope.viewCollection = ->
			documentSchemaId = $scope.attribute['configuration']['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			attribute = $scope.attribute
			collection = $scope.collection
			name = attribute['name']
			$modal.open(new ViewCollectionModal({name, attribute, collection, documentSchema}))

])
