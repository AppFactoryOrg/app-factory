angular.module('app-factory', [
	'angular-meteor'
	'ui.router'
	'ui.bootstrap'
	'toaster'
	'ui.sortable'
	'textAngular'
	'ngDragDrop'
])

angular.module('app-factory').config(['datepickerConfig', (datepickerConfig) ->
	datepickerConfig.appendToBody = true
	datepickerConfig.showWeeks = false
])

angular.module('app-factory').run(['$rootScope', '$state', 'toaster', ($rootScope, $state, toaster) ->
	$rootScope.$on '$stateChangeSuccess', (event, toState) ->
		window.scroll(0, 0)

	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		console.error(error)
		if error is 'AUTH_REQUIRED'
			console.warn('Unauthorized route - redirecting to login')
			$state.go('login')
		else
			toaster.pop(
				type: 'error'
				body: "#{error}"
				showCloseButton: true
			)
			$state.go('account')
])

