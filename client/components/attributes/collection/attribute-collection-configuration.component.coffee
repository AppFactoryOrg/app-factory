angular.module('app-factory').directive('afAttributeCollectionConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/collection/attribute-collection-configuration.template.html'
	replace: true
	scope:
		'attribute': 	'='
	link: ($scope) ->
		$scope.documentSchemas = DocumentSchema.db.find().fetch()
])