angular.module('app-factory').directive('afRegisterUserForm', [() ->
	restrict: 'E'
	templateUrl: 'client/components/register-user-form.template.html'
	scope:
		'onSubmit':		'&'
	link: ($scope) ->

		$scope.user =
			name: ''
			email: ''
			password: ''
			confirmPassword: ''
		
		$scope.showValidationErrors = false

		$scope.submit = ->
			if $scope.form.$invalid
				$scope.showValidationErrors = true
			else
				$scope.showValidationErrors = false
				$scope.onSubmit({user: $scope.user})
])
