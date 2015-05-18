angular.module('app-factory').controller('FactoryCtrl', ['$scope', '$rootScope', '$state', '$meteor', '$modal', 'GenericModal', 'application', 'environment', 'blueprint', ($scope, $rootScope, $state, $meteor, $modal, GenericModal, application, environment, blueprint) ->
		
	$meteor.subscribe('DocumentSchema',  'blueprint_id': blueprint['_id'])
	$meteor.subscribe('ViewSchema',  'blueprint_id': blueprint['_id'])
	
	$scope.application = $rootScope.application = application
	$scope.environment = $rootScope.environment = environment
	$scope.blueprint = $rootScope.blueprint = blueprint
	$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find('blueprint_id': $scope.blueprint['_id'])
	$scope.viewSchemas = $meteor.collection -> ViewSchema.db.find('blueprint_id': $scope.blueprint['_id'])
	$scope.blueprintStatuses = Utils.mapToArray(Blueprint.STATUS)

	$scope.documentsExpanded = $state.includes('factory.document')
	$scope.viewsExpanded = $state.includes('factory.view')
	$scope.routinesExpanded = false

	$scope.blueprintIsEditable = ->
		return $scope.blueprint.status is Blueprint.STATUS['Draft'].value

	$scope.documentSchemaIsSelected = (documentSchema) ->
		return $state.includes('factory.document', {'document_schema_id': documentSchema['_id']})

	$scope.viewSchemaIsSelected = (viewSchema) ->
		return $state.includes('factory.view', {'view_schema_id': viewSchema['_id']})

	$scope.logout = ->
		$meteor.logout()
		$state.go('login')

	$scope.createDocument = ->
		$modal.open(new GenericModal(
			title: 'New Document'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
				{name: 'description', displayAs: 'Description', type: 'textarea'}
			]
		)).result.then (parameters) ->
			parameters['blueprint_id'] = $scope.environment['blueprint_id']
			$meteor.call('DocumentSchema.create', parameters).then (document_schema_id) ->
				$state.go('factory.document', {document_schema_id})

	$scope.createViewSchema = ->
		$modal.open(new GenericModal(
			title: 'New View'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
				{name: 'description', displayAs: 'Description', type: 'textarea'}
			]
		)).result.then (parameters) ->
			parameters['blueprint_id'] = $scope.environment['blueprint_id']
			$meteor.call('ViewSchema.create', parameters).then (view_schema_id) ->
				$state.go('factory.view', {view_schema_id})

])