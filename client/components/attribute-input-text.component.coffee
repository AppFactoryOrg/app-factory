angular.module('app-factory').directive('afAttributeInputText', [() ->
	restrict: 'E'
	templateUrl: 'client/templates/attribute-input-text.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='		
])