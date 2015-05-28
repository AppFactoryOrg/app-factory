angular.module('app-factory').directive('afAttributeTextValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/text/attribute-text-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
])