angular.module('app-factory').directive('afAttributeDateInput', ['$filter', ($filter) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/date/attribute-date-input.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='	
	link: ($scope) ->
		if $scope.document['data'].hasOwnProperty($scope.attribute['id'])
			$scope.value = new Date($scope.document['data'][$scope.attribute['id']])

		$scope.valueUpdated = ->
			finalValue = null
			if $scope.value?
				finalValue = Date.parse($scope.value).valueOf()

			$scope.document['data'][$scope.attribute['id']] = finalValue
])