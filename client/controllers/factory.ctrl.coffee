angular.module('app-factory').controller('FactoryCtrl', ['$scope', '$state', '$meteor', '$modal', 'GenericModal', 'application', 'environment', 'blueprint', ($scope, $state, $meteor, $modal, GenericModal, application, environment, blueprint) ->
		
	$meteor.subscribe('DocumentSchema',  'blueprint_id': blueprint['_id'])
	
	$scope.application = application
	$scope.environment = environment
	$scope.blueprint = blueprint
	$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find('blueprint_id': $scope.blueprint['_id'])
	$scope.blueprintStatuses = Utils.mapToArray(Blueprint.STATUS)

	$scope.documentsExpanded = $state.includes('factory.document')
	$scope.viewsExpanded = false
	$scope.routinesExpanded = false

	$scope.blueprintIsEditable = ->
		return $scope.blueprint.status is Blueprint.STATUS['Draft'].value

	$scope.documentSchemaIsSelected = (documentSchema) ->
		return $state.includes('factory.document', {'document_schema_id': documentSchema['_id']})

	$scope.logout = ->
		$meteor.logout()
		$state.go('login')

	$scope.createDocument = ->
		$modal.open(new GenericModal(
			title: 'New Document'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
			]
		)).result.then (parameters) ->
			parameters['blueprint_id'] = $scope.environment['blueprint_id']
			$meteor.call('DocumentSchema.create', parameters).then (document_schema_id) ->
				$state.go('factory.document', {document_schema_id})

])