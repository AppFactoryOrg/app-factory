angular.module('app-factory').controller('DocumentSchemaCtrl', ['$scope', '$state', '$meteor', '$modal', 'documentSchema', 'EditAttributeModal', 'EditActionModal', ($scope, $state, $meteor, $modal, documentSchema, EditAttributeModal, EditActionModal) ->

	$scope.originalDocumentSchema = documentSchema
	$scope.documentSchema = documentSchema
	$scope.attributeDataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
	$scope.editMode = false
	$scope.sortableOptionsAttributes =
		containment: '#sort-bounds-attributes'
		containerPositioning: 'relative'
	$scope.sortableOptionsActions =
		containment: '#sort-bounds-actions'
		containerPositioning: 'relative'

	$scope.startEditDocumentSchema = ->
		$scope.editMode = true
		$scope.documentSchema = _.clone($scope.documentSchema)

	$scope.cancelEditDocumentSchema = ->
		return unless confirm('Are you sure you want to cancel? Unsaved changes will be lost.')
		$scope.editMode = false
		$scope.documentSchema = $scope.originalDocumentSchema

	$scope.saveDocumentSchema = ->
		documentSchema = angular.copy($scope.documentSchema)
		$meteor.call('DocumentSchema.update', documentSchema).then ->
			$scope.editMode = false
			$scope.documentSchema = documentSchema
			$scope.originalDocumentSchema = documentSchema

	$scope.deleteDocumentSchema = ->
		return unless confirm('Are you sure you want to delete this document? Application data may be lost.')
		$meteor.call('DocumentSchema.delete', $scope.documentSchema['_id']).then ->
			$state.go('factory.dashboard')

	$scope.newAttribute = ->
		$modal.open(new EditAttributeModal()).result.then (parameters) ->
			attribute = DocumentAttribute.new(parameters)
			$scope.documentSchema.attributes.push(attribute)

	$scope.editAttribute = (attribute) ->
		$modal.open(new EditAttributeModal(attribute)).result.then (parameters) ->
			_.assign(attribute, parameters)

	$scope.deleteAttribute = (attribute) ->
		return unless confirm('Are you sure you want to delete this attribute? Application data may be lost.')
		Utils.removeFromArray(attribute, $scope.documentSchema.attributes)

	$scope.getPrimaryAttributeName = ->
		attribute = _.find($scope.documentSchema['attributes'], {'id': $scope.documentSchema['primary_attribute_id']})
		return attribute?.name

	$scope.newAction = ->
		$modal.open(new EditActionModal()).result.then (parameters) ->
			action = DocumentAction.new(parameters)
			$scope.documentSchema.actions.push(action)

	$scope.editAction = (action) ->
		$modal.open(new EditActionModal(action)).result.then (parameters) ->
			_.assign(action, parameters)

	$scope.deleteAction = (action) ->
		return unless confirm('Are you sure you want to delete this action? Application data may be lost.')
		Utils.removeFromArray(action, $scope.documentSchema.actions)
])