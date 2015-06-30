angular.module('app-factory').directive('afAttributeDocumentFilter', ['$modal', 'SelectDocumentModal', 'DocumentUtils', ($modal, SelectDocumentModal, DocumentUtils) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-filter.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'filterValue': 	'='
	link: ($scope) ->

		key = "data.#{$scope.attribute['id']}"
		operators = DocumentAttribute.DATA_TYPE['Document'].operators

		$scope.operatorOptions = _.values(operators)
		$scope.operator = null
		$scope.value = null
		$scope.documentDisplayName = ''

		$scope.lookupDocument = ->
			documentSchemaId = $scope.attribute['configuration']['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			$modal.open(new SelectDocumentModal(documentSchema)).result.then (document) ->
				$scope.value = document['_id']
				$scope.operator = operators['is']
				$scope.updateFilterValue()
				$scope.loadDocument()

		$scope.loadDocument = ->
			documentId = $scope.value
			DocumentUtils.getPrimaryAttributeValue(documentId)
				.then (value) ->
					$scope.documentDisplayName = value
				.catch ->
					$scope.documentDisplayName = ''

		$scope.hasValue = ->
			return true if $scope.value isnt null
			return true if $scope.operator isnt null
			return false

		$scope.clear = ->
			$scope.value = null
			$scope.operator = null
			$scope.documentDisplayName = ''
			delete $scope.filterValue[key]

		$scope.updateFilterValue = ->
			value = $scope.value
			operator = $scope.operator

			if not operator? and value?
				$scope.operator = operator = operators['is']

			$scope.filterValue[key] = value

		$scope.$watch('filterValue', ->
			if $scope.filterValue is null or not $scope.filterValue.hasOwnProperty(key)
				$scope.operator = null
				$scope.value = null
				$scope.documentDisplayName = ''
				return

			$scope.value = $scope.filterValue[key]
			$scope.operator = operators['is']
			$scope.loadDocument()
		)
])
