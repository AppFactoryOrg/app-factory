angular.module('app-factory').directive('afAttributeNumberValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/number/attribute-number-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
	link: ($scope) ->
		$scope.getValue()
			.catch ->
				$scope.value = '[ERROR]'
			.then (value) ->
				$scope.value = value
])