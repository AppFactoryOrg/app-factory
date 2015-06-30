angular.module('app-factory').directive('afAttributeNumberFilter', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/number/attribute-number-filter.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'filterValue': 	'='
	link: ($scope) ->

		key = "data.#{$scope.attribute['id']}"
		operators = DocumentAttribute.DATA_TYPE['Number'].operators

		$scope.operatorOptions = _.values(operators)
		$scope.operator = null
		$scope.value1 = null
		$scope.value2 = null

		$scope.shouldShowValue2 = ->
			return $scope.operator is operators['between']

		$scope.hasValue = ->
			return true if $scope.value1 isnt null
			return true if $scope.value2 isnt null
			return true if $scope.operator isnt null
			return false

		$scope.reset = ->
			$scope.value1 = null
			$scope.value2 = null
			$scope.operator = null

		$scope.clear = ->
			delete $scope.filterValue[key]
			$scope.reset()

		$scope.updateFilterValue = ->
			value1 = $scope.value1
			value2 = $scope.value2
			operator = $scope.operator

			if operator is null and value1 isnt null
				$scope.operator = operator = operators['=']

			if not $scope.shouldShowValue2() and value2?
				value2 = null

			$scope.filterValue[key] = switch operator
				when operators['='] then value1
				when operators['>'] then {'$gt': value1}
				when operators['>='] then {'$gte': value1}
				when operators['<'] then {'$lt': value1}
				when operators['<='] then {'$lte': value1}
				when operators['between'] then {'$gte': value1, '$lte': value2}

		$scope.$watch('filterValue', ->
			if $scope.filterValue is null or not $scope.filterValue.hasOwnProperty(key)
				$scope.reset()
				return

			value = $scope.filterValue[key]
			if _.isObject(value)
				greaterThan = value['$gt']
				lessThan = value['$lt']
				greaterThanEqual = value['$gte']
				lessThanEqual = value['$lte']
				if greaterThanEqual isnt undefined and lessThanEqual isnt undefined
					$scope.operator = operators['between']
					$scope.value1 = greaterThanEqual
					$scope.value2 = lessThanEqual
				else if greaterThan isnt undefined
					$scope.operator = operators['>']
					$scope.value1 = greaterThan
				else if greaterThanEqual isnt undefined
					$scope.operator = operators['>=']
					$scope.value1 = greaterThanEqual
				else if lessThan isnt undefined
					$scope.operator = operators['<']
					$scope.value1 = lessThan
				else if lessThanEqual isnt undefined
					$scope.operator = operators['<=']
					$scope.value1 = lessThanEqual
			else
				$scope.value1 = value
				$scope.operator = operators['=']
		)
])
