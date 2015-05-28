angular.module('app-factory').directive('afAttributeDateInput', ['$filter', ($filter) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/date/attribute-date-input.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='	
	link: ($scope) ->
		$scope.calendarIsOpen = false
		$scope.calendarFormat = 'shortDate'

		if $scope.document['data'].hasOwnProperty($scope.attribute['id'])
			$scope.value = $filter('date')($scope.document['data'][$scope.attribute['id']], $scope.calendarFormat)

		$scope.valueUpdated = ->
			finalValue = null
			if $scope.value?
				finalValue = try Date.parse($scope.value).valueOf()

			$scope.document['data'][$scope.attribute['id']] = finalValue

		$scope.openCalendar = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$scope.calendarIsOpen = true
])