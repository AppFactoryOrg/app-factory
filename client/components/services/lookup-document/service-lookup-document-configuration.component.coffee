angular.module('app-factory').directive('afServiceLookupDocumentConfiguration', ['$compile', '$meteor', ($compile, $meteor) ->
	restrict: 'E'
	templateUrl: 'client/components/services/lookup-document/service-lookup-document-configuration.template.html'
	scope:
		'service': 	'='
])
