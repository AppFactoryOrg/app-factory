angular.module('app-factory').controller('LoginCtrl', ['$scope', '$state', '$meteor', 'toaster', ($scope, $state, $meteor, toaster) ->

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
				$state.go('account')
			, (err) ->
				console.error('login error - ', err)
				toaster.pop(
					type: 'error'
					body: 'Those credentials could not be verified. Please check the provided email and password.'
					showCloseButton: true
				)
			)

])