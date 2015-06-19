angular.module('app-factory').directive('afAttributeCollectionInput', ['$modal', 'ViewCollectionModal', ($modal, ViewCollectionModal) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/collection/attribute-collection-input.template.html'
	replace: true
	scope:
		'name':		'='
		'key': 		'='
		'object': 	'='
		'config':	'='	
	link: ($scope) ->
		$scope.object[$scope.key] = [] unless $scope.object[$scope.key]?
		$scope.collection = $scope.object[$scope.key]
		
		$scope.getLength = ->
			return $scope.collection.length if _.isArray($scope.collection)
			return 0

		$scope.editCollection = ->
			documentSchemaId = $scope.config['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			name = $scope.name
			collection = $scope.collection
			options =
				'edit': true
			$modal.open(new ViewCollectionModal({name, collection, documentSchema, options}))
])