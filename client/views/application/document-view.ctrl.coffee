angular.module('app-factory').controller('ApplicationDocumentViewCtrl', ['$scope', '$stateParams', '$timeout', ($scope, $stateParams, $timeout) ->
	$scope.documentSchema = DocumentSchema.db.findOne($stateParams.document_schema_id)
	$scope.views = $scope.documentSchema.views

	$scope.selectView = (view) ->
		$scope.loading = true
		$scope.selectedView = null
		$timeout ->
			$scope.selectedView = view
			$scope.loading = false

	# Initialize
	$scope.selectView(_.first($scope.views))
])
