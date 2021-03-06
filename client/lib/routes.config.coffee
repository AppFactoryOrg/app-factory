angular.module('app-factory').config(['$urlRouterProvider', '$stateProvider', '$locationProvider', ($urlRouterProvider, $stateProvider, $locationProvider) ->

	$locationProvider.html5Mode(true)
	$urlRouterProvider.otherwise('/account/applications')

	$stateProvider

		#####################################################################
		# ACCOUNT
		#####################################################################

		.state 'account',
			url: '/account'
			abstract: true
			controller: 'AccountCtrl'
			templateUrl: 'client/views/account/account.template.html'

		.state 'account.login',
			url: '/login?email&password'
			controller: 'AccountLoginCtrl'
			templateUrl: 'client/views/account/login.template.html'

		.state 'account.register',
			url: '/register'
			controller: 'AccountRegisterCtrl'
			templateUrl: 'client/views/account/register.template.html'

		.state 'account.forgot-password',
			url: '/forgot-password'
			controller: 'AccountForgotPasswordCtrl'
			templateUrl: 'client/views/account/forgot-password.template.html'

		.state 'account.applications',
			url: '/applications'
			controller: 'AccountApplicationsCtrl'
			templateUrl: 'client/views/account/applications.template.html'
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]

		.state 'account.billing',
			url: '/billing'
			controller: 'AccountBillingCtrl'
			templateUrl: 'client/views/account/billing.template.html'
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]

		.state 'reset-password',
			url: '/reset-password/:token'
			controller: 'AccountResetPasswordCtrl'
			templateUrl: 'client/views/account/reset-password.template.html'

		.state 'enroll-account',
			url: '/enroll-account/:token'
			controller: 'AccountEnrollCtrl'
			templateUrl: 'client/views/account/enroll.template.html'


		#####################################################################
		# FACTORY
		#####################################################################

		.state 'factory',
			url: '/factory/:environment_id'
			abstract: true
			templateUrl: 'client/views/factory/factory.template.html'
			controller: 'FactoryCtrl'
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]
				'environment': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) ->
					deferred = $q.defer()
					environment_id = $stateParams.environment_id
					$meteor.subscribe('Environment', environment_id)
						.catch (error) -> deferred.reject(error)
						.then ->
							environment = Environment.db.findOne(environment_id)
							deferred.resolve(environment) if environment?
							deferred.reject('Environment could not be found') unless environment?
					return deferred.promise
				]
				'application': ['$meteor', '$rootScope', '$q', 'environment', ($meteor, $rootScope, $q, environment) ->
					deferred = $q.defer()

					user_id = $rootScope.currentUser['_id']
					application_id = environment['application_id']
					throw new Error("User is not authorized to edit that application") unless User.canAccessApplication(user_id, application_id, true)

					$meteor.subscribe('Application', application_id)
						.catch (error) -> deferred.reject(error)
						.then ->
							application = Application.db.findOne(application_id)
							deferred.resolve(application) if application?
							deferred.reject('Application could not be found') unless application?
					return deferred.promise
				]
				'blueprint': ['$meteor', '$q', 'environment', ($meteor, $q, environment) ->
					deferred = $q.defer()
					blueprint_id = environment['blueprint_id']
					$q.all([
						$meteor.subscribe('Blueprint', {blueprint_id})
						$meteor.subscribe('DocumentSchemas', {blueprint_id})
						$meteor.subscribe('ScreenSchemas', {blueprint_id})
						$meteor.subscribe('Routines', {blueprint_id})
					])
					.catch (error) -> deferred.reject(error)
					.then ->
						blueprint = Blueprint.db.findOne(blueprint_id)
						deferred.resolve(blueprint) if blueprint?
						deferred.reject('Blueprint could not be found') unless blueprint?
					return deferred.promise
				]

		.state 'factory.dashboard',
			url: '/dashboard'
			templateUrl: 'client/views/factory/dashboard.template.html'

		.state 'factory.document',
			url: '/document/:document_schema_id',
			templateUrl: 'client/views/factory/document-schema.template.html'
			controller: 'DocumentSchemaCtrl',

		.state 'factory.screen',
			url: '/screen/:screen_schema_id',
			templateUrl: 'client/views/factory/screen-schema.template.html'
			controller: 'ScreenSchemaCtrl',

		.state 'factory.routines',
			url: '/routines'
			templateUrl: 'client/views/factory/routines.template.html'
			controller: 'FactoryRoutinesCtrl'

		.state 'factory.layout',
			url: '/layout'
			templateUrl: 'client/views/factory/layout.template.html'
			controller: 'FactoryLayoutCtrl'

		.state 'factory.theme',
			url: '/theme'
			templateUrl: 'client/views/factory/theme.template.html'

		.state 'factory.users',
			url: '/users'
			templateUrl: 'client/views/factory/users.template.html'
			controller: 'FactoryUsersCtrl'

		.state 'factory.settings',
			url: '/settings'
			templateUrl: 'client/views/factory/settings.template.html'
			controller: 'FactorySettingsCtrl'

	#####################################################################
	# APPLICATION
	#####################################################################

	.state 'application',
		url: '/application/:environment_id'
		templateUrl: 'client/views/application/application.template.html'
		controller: 'ApplicationCtrl'
		resolve:
			'currentUser': ['$meteor', ($meteor) ->
				return $meteor.requireUser()
			]
			'environment': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) ->
				deferred = $q.defer()
				environment_id = $stateParams.environment_id
				$meteor.subscribe('Environment', environment_id)
					.catch (error) -> deferred.reject(error)
					.then ->
						environment = Environment.db.findOne(environment_id)
						deferred.resolve(environment) if environment?
						deferred.reject('Environment could not be found') unless environment?
				return deferred.promise
			]
			'application': ['$meteor', '$q', '$rootScope', 'environment', ($meteor, $q, $rootScope, environment) ->
				deferred = $q.defer()

				user = $rootScope.currentUser
				application_id = environment['application_id']
				throw new Error("User is not authorized to access that application") unless User.canAccessApplication(user, application_id)

				$meteor.subscribe('Application', application_id)
					.catch (error) -> deferred.reject(error)
					.then ->
						application = Application.db.findOne(application_id)
						deferred.reject('Application could not be found') unless application?
						deferred.reject('Application is disabled. Contact your hosting administrator for more information.') unless application['enabled'] is true
						deferred.resolve(application) if application?
				return deferred.promise
			]
			'blueprint': ['$meteor', '$q', 'environment', ($meteor, $q, environment) ->
				deferred = $q.defer()
				blueprint_id = environment['blueprint_id']
				$q.all([
					$meteor.subscribe('Blueprint', {blueprint_id})
					$meteor.subscribe('DocumentSchemas', {blueprint_id})
					$meteor.subscribe('ScreenSchemas', {blueprint_id})
					$meteor.subscribe('Routines', {blueprint_id})
				])
				.catch (error) -> deferred.reject(error)
				.then ->
					blueprint = Blueprint.db.findOne(blueprint_id)
					deferred.resolve(blueprint) if blueprint?
					deferred.reject('Blueprint could not be found') unless blueprint?
				return deferred.promise
			]

	.state 'application.screen',
		url: '/screen/:screen_schema_id'
		templateUrl: 'client/views/application/screen.template.html'
		controller: 'ApplicationScreenCtrl'
])
