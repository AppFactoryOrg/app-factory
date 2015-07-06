angular.module('app-factory').directive('afAttributeDateValue', ['$filter', ($filter) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/date/attribute-date-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.$on 'ATTRIBUTE_VALUE', (e, value) ->
			if value?
				$scope.value = $filter('date')(value, 'shortDate')
			else
				$scope.value = null
])
