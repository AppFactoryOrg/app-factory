angular.module('app-factory').config(['$urlRouterProvider', '$stateProvider', ($urlRouterProvider, $stateProvider) ->

	$urlRouterProvider.otherwise '/account'

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
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]

		#####################################################################
		# FACTORY
		#####################################################################

		.state 'factory',
			url: '/factory/:application_id'
			abstract: true
			templateUrl: 'client/templates/factory.template.html'
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]

		.state 'factory.dashboard',
			url: '/dashboard'
			templateUrl: 'client/templates/dashboard.template.html'
])