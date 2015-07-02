angular.module('app-factory').controller('FactoryCtrl', ['$scope', '$rootScope', '$state', '$meteor', '$modal', 'GenericModal', 'application', 'environment', 'blueprint', ($scope, $rootScope, $state, $meteor, $modal, GenericModal, application, environment, blueprint) ->
		
	$scope.application = $rootScope.application = application
	$scope.environment = $rootScope.environment = environment
	$scope.blueprint = $rootScope.blueprint = blueprint
	$scope.documentSchemas = $scope.$meteorCollection -> DocumentSchema.db.find('blueprint_id': $scope.blueprint['_id'])
	$scope.screenSchemas = $scope.$meteorCollection -> ScreenSchema.db.find('blueprint_id': $scope.blueprint['_id'])
	$scope.routines = $scope.$meteorCollection -> Routine.db.find('blueprint_id': $scope.blueprint['_id'], {sort: {'created_on': -1}})
	$scope.blueprintStatuses = Utils.mapToArray(Blueprint.STATUS)

	$scope.documentsExpanded = $state.includes('factory.document')
	$scope.screensExpanded = $state.includes('factory.screen')

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.blueprintIsEditable = ->
		return $scope.blueprint.status is Blueprint.STATUS['Draft'].value

	$scope.documentSchemaIsSelected = (documentSchema) ->
		return $state.includes('factory.document', {'document_schema_id': documentSchema['_id']})

	$scope.screenSchemaIsSelected = (screenSchema) ->
		return $state.includes('factory.screen', {'screen_schema_id': screenSchema['_id']})

	$scope.getApplicationUrl = ->
		return $state.href('application', 'environment_id': $rootScope.environment['_id'])

	$scope.logout = ->
		$meteor.logout()
		$state.go('account.login')

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

	$scope.createScreenSchema = ->
		$modal.open(new GenericModal(
			title: 'New Screen'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name', required: true, autofocus: true}
				{name: 'description', displayAs: 'Description', type: 'textarea'}
			]
		)).result.then (parameters) ->
			parameters['blueprint_id'] = $scope.environment['blueprint_id']
			$meteor.call('ScreenSchema.create', parameters).then (screen_schema_id) ->
				$state.go('factory.screen', {screen_schema_id})

])