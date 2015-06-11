angular.module('app-factory').directive('afAttributeDateValue', ['$filter', ($filter) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/date/attribute-date-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.getValue().then (value) ->
			value = $filter('date')(value, 'shortDate') if value?
			$scope.value = value
])