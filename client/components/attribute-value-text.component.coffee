angular.module('app-factory').directive('afAttributeValueText', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/attribute-value-text.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
])