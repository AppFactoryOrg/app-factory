angular.module('app-factory').directive('afAttributeDocumentFilter', ['$modal', 'SelectDocumentModal', ($modal, SelectDocumentModal) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-filter.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'filterValue': 	'='		
	link: ($scope) ->

		key = "data.#{$scope.attribute['id']}"

		$scope.operatorOptions = ['is']
		$scope.operator = null
		$scope.value = null

		$scope.getDocumentDisplayName = ->
			return $scope.value

		$scope.lookupDocument = ->
			documentSchemaId = $scope.attribute['configuration']['document_schema_id']
			documentSchema = DocumentSchema.db.findOne(documentSchemaId)
			$modal.open(new SelectDocumentModal(documentSchema)).result.then (document) ->
				$scope.value = document['_id']
				$scope.operator = 'is'
				$scope.updateFilterValue()

		$scope.hasValue = ->
			return true if $scope.value isnt null
			return true if $scope.operator isnt null
			return false

		$scope.clear = ->
			$scope.value = null
			$scope.operator = null
			delete $scope.filterValue[key]

		$scope.updateFilterValue = ->
			value = $scope.value
			operator = $scope.operator

			if not operator? and value?
				$scope.operator = operator = 'is'

			$scope.filterValue[key] = value

		$scope.$watch('filterValue', ->
			if $scope.filterValue is null or not $scope.filterValue.hasOwnProperty(key)
				$scope.operator = null
				$scope.value = null
				return

			$scope.value = $scope.filterValue[key]
			$scope.operator = 'is'
		)
])