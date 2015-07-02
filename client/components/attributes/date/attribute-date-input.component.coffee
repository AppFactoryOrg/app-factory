angular.module('app-factory').directive('afAttributeDateInput', ['$filter', ($filter) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/date/attribute-date-input.template.html'
	replace: true
	scope:
		'key': 		'='
		'object': 	'='
		'config':	'='
	link: ($scope) ->
		$scope.calendarIsOpen = false
		$scope.calendarFormat = 'shortDate'

		if $scope.object.hasOwnProperty($scope.key)
			$scope.value = $filter('date')($scope.object[$scope.key], $scope.calendarFormat)

		$scope.valueUpdated = ->
			finalValue = null
			if $scope.value?
				finalValue = try Date.parse($scope.value).valueOf()

			$scope.object[$scope.key] = finalValue

		$scope.openCalendar = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$scope.calendarIsOpen = true
])