angular.module('app-factory').controller('DocumentSchemaCtrl', ['$scope', '$state', '$meteor', 'documentSchema', ($scope, $state, $meteor, documentSchema) ->

	$scope.documentSchema = documentSchema

])