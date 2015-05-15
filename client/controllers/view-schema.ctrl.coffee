angular.module('app-factory').controller('ViewSchemaCtrl', ['$scope', '$state', '$meteor', '$modal', 'viewSchema', 'GenericModal', ($scope, $state, $meteor, $modal, viewSchema, GenericModal) ->

	$scope.originalViewSchema = viewSchema
	$scope.viewSchema = viewSchema
	$scope.editMode = false

	$scope.startEditViewSchema = ->
		$scope.editMode = true
		$scope.viewSchema = _.clone($scope.originalViewSchema)

	$scope.cancelEditViewSchema = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.viewSchema = $scope.originalViewSchema

	$scope.saveViewSchema = ->
		viewSchema = ViewSchema.bakeWidgetHierarchy($scope.viewSchema)
		$meteor.call('ViewSchema.update', viewSchema).then ->
			$scope.editMode = false
			ViewSchema.buildWidgetHierarchy(viewSchema)
			$scope.viewSchema = viewSchema
			$scope.originalViewSchema = $scope.viewSchema

	$scope.deleteViewSchema = ->
		return unless confirm('Are you sure you want to delete this viewSchema?')
		$meteor.call('ViewSchema.delete', $scope.viewSchema['_id']).then ->
			$state.go('factory.dashboard')

])