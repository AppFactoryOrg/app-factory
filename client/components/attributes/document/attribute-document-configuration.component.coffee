angular.module('app-factory').directive('afAttributeDocumentConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/document/attribute-document-configuration.template.html'
	replace: true
	scope:
		'attribute': 	'='
	link: ($scope) ->
		$scope.documentSchemas = DocumentSchema.db.find().fetch()
])