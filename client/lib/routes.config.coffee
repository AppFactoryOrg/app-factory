angular.module('app-factory').config ($urlRouterProvider, $stateProvider) ->

	$stateProvider

		#####################################################################
		# USER
		#####################################################################

		.state 'login',
			url: '/login'
			templateUrl: 'client/templates/login.template.html'

		.state 'register',
			url: '/register'
			templateUrl: 'client/templates/register.template.html'

		.state 'account',
			url: '/account'
			templateUrl: 'client/templates/account.template.html'
			resolve: {
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]
			}