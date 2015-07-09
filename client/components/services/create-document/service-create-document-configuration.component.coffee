angular.module('app-factory').directive('afServiceCreateDocumentConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/services/create-document/service-create-document-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.documentSchemas = DocumentSchema.db.find().fetch()
])
