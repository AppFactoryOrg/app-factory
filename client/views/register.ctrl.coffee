angular.module('app-factory').controller('RegisterCtrl', ['$scope', '$state', '$meteor', 'toaster', ($scope, $state, $meteor, toaster) ->

	$scope.name = ''
	$scope.email = ''
	$scope.password = ''
	$scope.confirmPassword = ''
	$scope.showValidationErrors = false

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.submit = ->
		if $scope.form.$invalid
			$scope.showValidationErrors = true
			return
		else
			$scope.showValidationErrors = false

			$meteor.createUser(
				email: $scope.email
				password: $scope.password,
				profile: {name: $scope.name}
			).then( ->
				console.log('Registration successful')
				$state.go('account')
			, (err) ->
				console.error('Registration error - ', err)
				toaster.pop(
					type: 'error'
					body: 'There was an error processing your registration.'
					showCloseButton: true
				)
			)

])