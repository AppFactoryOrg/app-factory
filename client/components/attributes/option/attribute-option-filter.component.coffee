angular.module('app-factory').directive('afAttributeOptionFilter', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/option/attribute-option-filter.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'filterValue': 	'='
	link: ($scope) ->

		key = "data.#{$scope.attribute['id']}"
		operators = DocumentAttribute.DATA_TYPE['Option'].operators

		$scope.options = _.filter($scope.attribute['configuration']['options'], 'active': true)
		$scope.operatorOptions = _.values(operators)
		$scope.operator = null
		$scope.value = null

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
				$scope.operator = operator = operators['is']

			$scope.filterValue[key] = value

		$scope.$watch('filterValue', ->
			if $scope.filterValue is null or not $scope.filterValue.hasOwnProperty(key)
				$scope.operator = null
				$scope.value = null
				return

			value = $scope.filterValue[key]
			$scope.value = value
			$scope.operator = operators['is']
		)
])
