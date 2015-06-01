angular.module('app-factory').directive('afAttributeOptionInput', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/option/attribute-option-input.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope) ->
		$scope.options = _.filter($scope.attribute['configuration']['options'], 'active': true)		
])