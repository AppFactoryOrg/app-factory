angular.module('app-factory').directive('afAttributeNumberInput', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/number/attribute-number-input.template.html'
	replace: true
	scope:
		'key': 		'='
		'object': 	'='
		'config':	'='	
])