angular.module('app-factory').directive('afAttributeDateValue', ['$filter', ($filter) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/date/attribute-date-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->
		value = $scope.document['data'][$scope.attribute['id']]
		value = $filter('date')(value, 'shortDate') if value?
		$scope.value = value
])