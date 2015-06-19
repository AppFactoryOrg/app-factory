angular.module('app-factory').directive('afAttributeTextInput', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/text/attribute-text-input.template.html'
	replace: true
	scope:
		'key': 		'='
		'object': 	'='
		'config':	'='
])