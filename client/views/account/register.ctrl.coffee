angular.module('app-factory').controller('AccountRegisterCtrl', ['$scope', '$meteor', 'toaster', ($scope, $meteor, toaster) ->

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.user =
		name: ''
		email: ''
	
	$scope.showValidationErrors = false
	$scope.showRegisterForm = true
	$scope.showSuccessMessage = false

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
		else
			$scope.showValidationErrors = false

			$meteor.call('User.register', $scope.user)
				.then ->
					$scope.showRegisterForm = false
					$scope.showSuccessMessage = true
				.catch (error) ->
					toaster.pop(
						type: 'error'
						body: "Registration failed. #{error.reason}"
						showCloseButton: true
					)

])