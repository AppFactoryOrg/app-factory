angular.module('app-factory', [
	'angular-meteor'
	'ui.router'
	'ui.bootstrap'
	'toaster'
	'ui.sortable'
	'textAngular'
])

angular.module('app-factory').run(['$rootScope', '$state', ($rootScope, $state) ->
	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		if error is 'AUTH_REQUIRED'
			console.error('Unauthorized route - redirecting to login')
			$state.go('login')
])