angular.module('app-factory').controller('AccountCtrl', ['$scope', '$meteor', '$state', '$modal', 'GenericModal', ($scope, $meteor, $state, $modal, GenericModal) ->

	$meteor.subscribe('Application')
	$scope.applications = $meteor.collection -> Application.db.find()

	$scope.logout = ->
		$meteor.logout()
		$state.go('login')

	$scope.createApplication = ->
		$modal.open(new GenericModal(
			title: 'Create Application'
			submitAction: 'Create'
			attributes: [
				{name: 'name', displayAs: 'Name'}
			]
		)).result.then (application) ->
			$meteor.call('Application.create', application)

	$scope.edit = (application) ->
		$state.go('factory.dashboard', 'application_id': application['_id'])

])