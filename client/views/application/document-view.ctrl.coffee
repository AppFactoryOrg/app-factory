angular.module('app-factory').controller('ApplicationDocumentViewCtrl', ['$scope', '$stateParams', '$timeout', ($scope, $stateParams, $timeout) ->
	$scope.documentSchema = DocumentSchema.db.findOne($stateParams.document_schema_id)
	$scope.views = $scope.documentSchema.views
	$scope.selectedView = _.first($scope.views)

	$scope.selectView = (view) ->
		$scope.selectedView = null
		$timeout ->
			$scope.selectedView = view
])
