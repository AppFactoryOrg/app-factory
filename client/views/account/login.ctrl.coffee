angular.module('app-factory').controller('AccountLoginCtrl', ['$scope', '$state', '$meteor', 'toaster', ($scope, $state, $meteor, toaster) ->

	$scope.email = ''
	$scope.password = ''
	$scope.showValidationErrors = false

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

		$meteor.loginWithPassword(
			$scope.email,
			$scope.password
		).then( ->
			console.log('Login successful')
			$state.go('account.applications')
		, (error) ->
			console.error(error)
			toaster.pop(
				type: 'error'
				body: error['reason']
				showCloseButton: true
			)
		)

])
