angular.module('app-factory').directive('afAttributeDocumentInput', ['$modal', 'SelectDocumentModal', 'DocumentUtils', ($modal, SelectDocumentModal, DocumentUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-input.template.html'
	replace: true
	scope:
		'key': 		'='
		'object': 	'='
		'config':	'='	
	link: ($scope) ->

		$scope.documentDisplayName = ''

		$scope.hasValue = ->
			return $scope.object[$scope.key]?

		$scope.lookupDocument = ->
			documentSchemaId = $scope.config['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			$modal.open(new SelectDocumentModal(documentSchema)).result.then (document) ->
				$scope.object[$scope.key] = document['_id']
				$scope.loadDocument()

		$scope.clearDocument = ->
			$scope.object[$scope.key] = null
			$scope.loadDocument()

		$scope.loadDocument = ->
			documentId = $scope.object[$scope.key]
			DocumentUtils.getPrimaryAttributeValue(documentId)
				.then (value) ->
					$scope.documentDisplayName = value
				.catch ->
					$scope.documentDisplayName = null

		# Initialize
		$scope.loadDocument()
])