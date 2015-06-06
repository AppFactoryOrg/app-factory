angular.module('app-factory').controller('EnrollAccountCtrl', ['$scope', '$stateParams', '$state', 'toaster', ($scope, $stateParams, $state, toaster) ->

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.password = ''
	$scope.confirmPassword = ''
	
	$scope.showValidationErrors = false

	console.log $stateParams.token

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
		else
			$scope.showValidationErrors = false

			token = $stateParams.token
			password = $scope.password

			Accounts.resetPassword(token, password, (error) ->
				if error?
					console.error(error)
					toaster.pop(
						type: 'error'
						body: "Activation failed. #{error}"
						showCloseButton: true
					)
				else
					$state.go('account')
			)

])