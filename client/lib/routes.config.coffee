angular.module('app-factory').config(['$urlRouterProvider', '$stateProvider', ($urlRouterProvider, $stateProvider) ->

	$urlRouterProvider.otherwise '/account'

	$stateProvider

		#####################################################################
		# USER
		#####################################################################

		.state 'login',
			url: '/login'
			controller: 'LoginCtrl'
			templateUrl: 'client/templates/login.template.html'

		.state 'register',
			url: '/register'
			controller: 'RegisterCtrl'
			templateUrl: 'client/templates/register.template.html'

		.state 'account',
			url: '/account'
			controller: 'AccountCtrl'
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
			controller: 'FactoryCtrl'
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]
				'application': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) -> 
					deferred = $q.defer()
					applicationId = $stateParams.application_id
					$meteor.subscribe('Application', applicationId).then ->
						application = Application.db.findOne(applicationId)
						deferred.resolve(application) if application?
						deferred.reject('Application could not be found') unless application?
					return deferred.promise
				]

		.state 'factory.dashboard',
			url: '/dashboard'
			templateUrl: 'client/templates/factory-dashboard.template.html'

		.state 'factory.users',
			url: '/users'
			templateUrl: 'client/templates/factory-users.template.html'

		.state 'factory.settings',
			url: '/settings'
			templateUrl: 'client/templates/factory-settings.template.html'
])