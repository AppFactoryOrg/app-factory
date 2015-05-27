angular.module('app-factory').controller('ScreenSchemaCtrl', ['$scope', '$state', '$meteor', '$modal', 'screenSchema', 'GenericModal', ($scope, $state, $meteor, $modal, screenSchema, GenericModal) ->

	$scope.originalScreenSchema = screenSchema
	$scope.screenSchema = screenSchema
	$scope.editMode = false

	$scope.startEditScreenSchema = ->
		$scope.editMode = true
		$scope.screenSchema = _.clone($scope.originalScreenSchema)

	$scope.cancelEditScreenSchema = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.screenSchema = $scope.originalScreenSchema

	$scope.saveScreenSchema = ->
		screenSchema = ScreenSchema.bakeWidgetHierarchy($scope.screenSchema)
		$meteor.call('ScreenSchema.update', screenSchema).then ->
			$scope.editMode = false
			ScreenSchema.buildWidgetHierarchy(screenSchema)
			$scope.screenSchema = screenSchema
			$scope.originalScreenSchema = $scope.screenSchema

	$scope.deleteScreenSchema = ->
		return unless confirm('Are you sure you want to delete this screenSchema?')
		$meteor.call('ScreenSchema.delete', $scope.screenSchema['_id']).then ->
			$state.go('factory.dashboard')

])