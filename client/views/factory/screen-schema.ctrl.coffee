angular.module('app-factory').controller('ScreenSchemaCtrl', ['$scope', '$state', '$stateParams', '$meteor', '$modal', 'GenericModal', ($scope, $state, $stateParams, $meteor, $modal, GenericModal) ->

	$scope.screenSchema = ScreenSchema.db.findOne($stateParams.screen_schema_id)
	ScreenSchema.buildWidgetHierarchy($scope.screenSchema)
	$scope.editMode = false

	$scope.startEditScreenSchema = ->
		$scope.editMode = true
		$scope.screenSchema = _.cloneDeep($scope.screenSchema)

	$scope.cancelEditScreenSchema = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.screenSchema = ScreenSchema.db.findOne($stateParams.screen_schema_id)
		ScreenSchema.buildWidgetHierarchy($scope.screenSchema)

	$scope.saveScreenSchema = ->
		screenSchema = ScreenSchema.bakeWidgetHierarchy($scope.screenSchema)
		$meteor.call('ScreenSchema.update', screenSchema).then ->
			$scope.editMode = false
			ScreenSchema.buildWidgetHierarchy(screenSchema)
			$scope.screenSchema = screenSchema

	$scope.deleteScreenSchema = ->
		return unless confirm('Are you sure you want to delete this screenSchema?')
		$meteor.call('ScreenSchema.delete', $scope.screenSchema['_id']).then ->
			$state.go('factory.dashboard')

])
