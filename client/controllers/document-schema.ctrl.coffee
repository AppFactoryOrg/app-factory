angular.module('app-factory').controller('DocumentSchemaCtrl', ['$scope', '$state', '$meteor', '$modal', 'documentSchema', 'GenericModal', ($scope, $state, $meteor, $modal, documentSchema, GenericModal) ->

	$scope.originalDocumentSchema = documentSchema
	$scope.documentSchema = documentSchema
	$scope.attributeTypes = DocumentSchema.ATTRIBUTE_TYPE

	$scope.selectedAttribute = null
	$scope.editMode = false

	$scope.startEditDocumentSchema = ->
		$scope.editMode = true
		$scope.documentSchema = angular.copy($scope.originalDocumentSchema)

	$scope.cancelEditDocumentSchema = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.documentSchema = $scope.originalDocumentSchema

	$scope.saveDocumentSchema = ->
		documentSchema = angular.copy($scope.documentSchema)
		$meteor.call('DocumentSchema.update', documentSchema)
			.catch (err) ->
				console.error err
			.then ->
				$scope.editMode = false
				$scope.originalDocumentSchema = documentSchema

	$scope.deleteDocumentSchema = ->
		return unless confirm('Are you sure you want to delete this document? Application data will be lost.')
		$meteor.call('DocumentSchema.delete', $scope.documentSchema['_id']).then ->
			$state.go('factory.dashboard')

	$scope.newAttribute = ->
		$modal.open(new GenericModal(
			title: 'New Attribute'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
				{name: 'type', displayAs: 'Type', type: 'select', options: DocumentSchema.ATTRIBUTE_TYPE, required: true}
			]
		)).result.then (attribute) ->
			attribute['id'] = DocumentSchema.getNextAttributeId($scope.documentSchema)
			$scope.documentSchema.attributes.push(attribute)

	$scope.selectAttribute = (attribute) ->
		$scope.selectedAttribute = attribute
])