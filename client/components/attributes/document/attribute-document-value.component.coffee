angular.module('app-factory').directive('afAttributeDocumentValue', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-value.template.html'
	replace: true
	scope:
		'attribute': 	'='
		'document': 	'='
	controller: 'CommonAttributeValueCtrl'
])