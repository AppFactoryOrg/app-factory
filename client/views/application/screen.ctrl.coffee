angular.module('app-factory').controller('ApplicationScreenCtrl', ['$scope', '$rootScope', '$stateParams', ($scope, $rootScope, $stateParams) ->

	$scope.screenSchema = ScreenSchema.db.findOne($stateParams.screen_schema_id)
	ScreenSchema.buildWidgetHierarchy($scope.screenSchema)

])
