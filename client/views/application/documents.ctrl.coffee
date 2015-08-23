angular.module('app-factory').controller('ApplicationDocumentsCtrl', ['$scope', '$state', '$rootScope', ($scope, $state, $rootScope) ->
	$scope.documentSchemas = $scope.$meteorCollection -> DocumentSchema.db.find('blueprint_id': $rootScope.blueprint['_id'])

	$scope.goToDocument = (documentSchema) ->
		document_schema_id = documentSchema['_id']
		$state.go('application.document-view', {document_schema_id})
])
