angular.module('app-factory').controller('AccountForgotPasswordCtrl', ['$scope', '$meteor', 'toaster', ($scope, $meteor, toaster) ->

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.user =
		email: ''
	
	$scope.showValidationErrors = false
	$scope.showForm = true
	$scope.showSuccessMessage = false

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
		else
			$scope.showValidationErrors = false

			Accounts.forgotPassword($scope.user, (error) -> $scope.$apply ->
				if error?
					console.error(error)
					toaster.pop(
						type: 'error'
						body: "Request failed. #{error.reason}"
						showCloseButton: true
					)
				else
					$scope.showForm = false
					$scope.showSuccessMessage = true
			)
])