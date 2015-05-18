angular.module('app-factory').controller('DocumentSchemaCtrl', ['$scope', '$state', '$meteor', '$modal', 'documentSchema', 'GenericModal', ($scope, $state, $meteor, $modal, documentSchema, GenericModal) ->

	$scope.originalDocumentSchema = documentSchema
	$scope.documentSchema = documentSchema
	$scope.attributeDataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
	$scope.attributeValueTypes = Utils.mapToArray(DocumentAttribute.VALUE_TYPE)
	$scope.selectedAttribute = null
	$scope.editMode = false

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
		$modal.open(new GenericModal(
			title: 'New Attribute'
			submitAction: 'Create'
			attributes: [
				{
					name: 'name'
					displayAs: 'Name'
					required: true
					autofocus: true
				}
				{
					name: 'data_type'
					displayAs: 'Data Type'
					type: 'select'
					options: $scope.attributeDataTypes
					required: true
				}
				{
					name: 'value_type'
					displayAs: 'Value Type'
					type: 'select'
					options: $scope.attributeValueTypes
					required: true
				}
			]
		)).result.then (parameters) ->
			attribute = DocumentAttribute.new()
			attribute['name'] = parameters['name']
			attribute['data_type'] = parameters['data_type']
			attribute['value_type'] = parameters['value_type']
			$scope.documentSchema.attributes.push(attribute)

	$scope.selectAttribute = (attribute) ->
		$scope.selectedAttribute = attribute

	$scope.deleteAttribute = ->
		return unless confirm('Are you sure you want to delete this attribute? Application data may be lost.')
		Utils.removeFromArray($scope.selectedAttribute, $scope.documentSchema.attributes)
		$scope.selectedAttribute = null

	$scope.attributeHasDefaultValue = (attribute) ->
		return DocumentAttribute.hasDefaultValue(attribute)

	$scope.attributeHasRoutineId = (attribute) ->
		return DocumentAttribute.hasRoutineId(attribute)

])