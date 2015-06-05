angular.module('app-factory').controller('RegisterCtrl', ['$scope', '$state', '$meteor', 'toaster', ($scope, $state, $meteor, toaster) ->

	$('body').removeClass()
	$('body').addClass('boxed-layout')

	$scope.submit = (user) ->
		$meteor.call('User.register', user)
			.catch (error) ->
				toaster.pop(
					type: 'error'
					body: "Registration failed. #{error.reason}"
					showCloseButton: true
				)

])