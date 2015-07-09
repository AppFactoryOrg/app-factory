angular.module('app-factory', [
	'angular-meteor'
	'ui.router'
	'ui.bootstrap'
	'toaster'
	'ui.sortable'
	'textAngular'
	'ngDragDrop'
	'panhandler'
])

angular.module('app-factory').config(['datepickerConfig', (datepickerConfig) ->
	datepickerConfig.appendToBody = true
	datepickerConfig.showWeeks = false
])

angular.module('app-factory').run(['$rootScope', '$state', 'toaster', '$modalStack', ($rootScope, $state, toaster, $modalStack) ->

	$rootScope.version = 'v1.0.2'

	$rootScope.$on '$locationChangeStart', (event) ->
		top = $modalStack.getTop()
		if top?
			event.preventDefault()

	$rootScope.$on '$stateChangeSuccess', (event, toState) ->
		window.scroll(0, 0)

	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		console.error(error)
		if error is 'AUTH_REQUIRED'
			console.warn('Unauthorized route - redirecting to login')
			$state.go('account.login')
		else
			toaster.pop(
				type: 'error'
				body: "#{error}"
				showCloseButton: true
			)
			$state.go('account.applications')


])

angular.module('app-factory').factory('$exceptionHandler', ->
	return (error, cause) ->
		console.error(error)
		Utils.logError(error)
)

window.onerror = (message, file, line_number, column_number, error_object) ->
	if error_object?
		error = error_object
	else
		error =
			'message': message
			'stack': "#{file} #{line_number}:#{column_number}"

	Utils.logError(error)
