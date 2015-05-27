angular.module('app-factory').directive('afAttributeNumberFilter', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/number/attribute-number-filter.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'filterValue': 	'='		
	link: ($scope) ->

		key = "data.#{$scope.attribute['id']}"

		$scope.operatorOptions = ['equals', 'greater than', 'less than', 'between']
		$scope.operator = null
		$scope.value1 = null
		$scope.value2 = null

		$scope.shouldShowValue2 = ->
			return $scope.operator in ['between']

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
				$scope.operator = operator = 'equals'

			if not $scope.shouldShowValue2() and value2?
				value2 = null 

			$scope.filterValue[key] = switch operator
				when 'equals' then value1
				when 'greater than' then {'$gt': value1}
				when 'less than' then {'$lt': value1}
				when 'between' then {'$gt': value1, '$lt': value2}

		$scope.$watch('filterValue', ->
			if $scope.filterValue is null or not $scope.filterValue.hasOwnProperty(key)
				$scope.reset()
				return

			value = $scope.filterValue[key]
			if _.isObject(value)
				greaterThan = value['$gt']
				lessThan = value['$lt']
				if greaterThan? and lessThan?
					$scope.operator = 'between'
					$scope.value1 = greaterThan
					$scope.value2 = lessThan
				else if greaterThan?
					$scope.operator = 'greater than'
					$scope.value1 = greaterThan
				else if lessThan?
					$scope.operator = 'less than'
					$scope.value1 = lessThan
			else
				$scope.value1 = value
				$scope.operator = 'equals'
		)
])