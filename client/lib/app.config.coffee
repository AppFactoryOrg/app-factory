angular.module('app-factory', [
	'angular-meteor'
	'ui.router'
	'ui.bootstrap'
	'toaster'
	'ui.sortable'
	'textAngular'
	'ngDragDrop'
	'panhandler'
	'ui.gravatar'
])

angular.module('app-factory').config(['datepickerConfig', (datepickerConfig) ->
	datepickerConfig.appendToBody = true
	datepickerConfig.showWeeks = false
])

angular.module('app-factory').config(['gravatarServiceProvider', (gravatarServiceProvider) ->
	gravatarServiceProvider.defaults =
		"size": 100
		"default": 'mm'
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
	return (exception, cause) ->
		exception.message += " (caused by #{cause})"
		console.error(exception)
		throw exception
)

Meteor.startup ->
	if Meteor.settings.public.billing_is_enabled
		Stripe.setPublishableKey(Meteor.settings.public.stripe_publishable_key)
