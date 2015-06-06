angular.module('app-factory').config(['$urlRouterProvider', '$stateProvider', ($urlRouterProvider, $stateProvider) ->

	$urlRouterProvider.otherwise '/account'

	$stateProvider

		#####################################################################
		# USER
		#####################################################################

		.state 'login',
			url: '/login'
			controller: 'LoginCtrl'
			templateUrl: 'client/views/login.template.html'

		.state 'register',
			url: '/register'
			controller: 'RegisterCtrl'
			templateUrl: 'client/views/register.template.html'

		.state 'enroll-account',
			url: '/enroll-account/:token'
			controller: 'EnrollAccountCtrl'
			templateUrl: 'client/views/enroll-account.template.html'

		.state 'account',
			url: '/account'
			controller: 'AccountCtrl'
			templateUrl: 'client/views/account.template.html'
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]

		#####################################################################
		# FACTORY
		#####################################################################

		.state 'factory',
			url: '/factory/:environment_id'
			abstract: true
			templateUrl: 'client/views/factory.template.html'
			controller: 'FactoryCtrl'
			resolve:
				'currentUser': ['$meteor', ($meteor) ->
					return $meteor.requireUser()
				]
				'environment': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) -> 
					deferred = $q.defer()
					environment_id = $stateParams.environment_id
					$meteor.subscribe('Environment', {environment_id}).then ->
						environment = Environment.db.findOne(environment_id)
						deferred.resolve(environment) if environment?
						deferred.reject('Environment could not be found') unless environment?
					return deferred.promise
				]
				'application': ['$meteor', '$rootScope', '$q', 'environment', ($meteor, $rootScope, $q, environment) -> 
					deferred = $q.defer()
					
					user = $rootScope.currentUser
					application_id = environment['application_id']
					throw new Error("User is not authorized to edit that application") unless User.canEditApplication({user, application_id})

					$meteor.subscribe('Application', application_id).then ->
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
						$meteor.subscribe('DocumentSchema', {blueprint_id})
						$meteor.subscribe('ScreenSchema', {blueprint_id})
					]).then ->
						blueprint = Blueprint.db.findOne(blueprint_id)
						deferred.resolve(blueprint) if blueprint?
						deferred.reject('Blueprint could not be found') unless blueprint?
					return deferred.promise
				]

		.state 'factory.dashboard',
			url: '/dashboard'
			templateUrl: 'client/views/factory-dashboard.template.html'

		.state 'factory.document',
			url: '/document/:document_schema_id',
			templateUrl: 'client/views/document-schema.template.html'
			controller: 'DocumentSchemaCtrl',
			resolve: 
				'documentSchema': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) -> 
					deferred = $q.defer()
					document_schema_id = $stateParams.document_schema_id
					$meteor.subscribe('DocumentSchema', {document_schema_id}).then ->
						documentSchema = DocumentSchema.db.findOne(document_schema_id)
						deferred.resolve(documentSchema) if documentSchema?
						deferred.reject('Document could not be found') unless documentSchema?
					return deferred.promise
				]

		.state 'factory.screen',
			url: '/screen/:screen_schema_id',
			templateUrl: 'client/views/screen-schema.template.html'
			controller: 'ScreenSchemaCtrl',
			resolve: 
				'screenSchema': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) -> 
					deferred = $q.defer()
					screen_schema_id = $stateParams.screen_schema_id
					$meteor.subscribe('ScreenSchema', {screen_schema_id}).then ->
						screenSchema = ScreenSchema.db.findOne(screen_schema_id)
						ScreenSchema.buildWidgetHierarchy(screenSchema)
						deferred.resolve(screenSchema) if screenSchema?
						deferred.reject('ScreenSchema could not be found') unless screenSchema?
					return deferred.promise
				]

		.state 'factory.layout',
			url: '/layout'
			templateUrl: 'client/views/factory-layout.template.html'
			controller: 'FactoryLayoutCtrl'

		.state 'factory.theme',
			url: '/theme'
			templateUrl: 'client/views/factory-theme.template.html'

		.state 'factory.users',
			url: '/users'
			templateUrl: 'client/views/factory-users.template.html'
			controller: 'FactoryUsersCtrl'

		.state 'factory.settings',
			url: '/settings'
			templateUrl: 'client/views/factory-settings.template.html'
			controller: 'FactorySettingsCtrl'

	#####################################################################
	# APPLICATION
	#####################################################################

	.state 'application',
		url: '/application/:environment_id'
		templateUrl: 'client/views/application.template.html'
		controller: 'ApplicationCtrl'
		resolve:
			'currentUser': ['$meteor', ($meteor) ->
				return $meteor.requireUser()
			]
			'environment': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) -> 
				deferred = $q.defer()
				environment_id = $stateParams.environment_id
				$meteor.subscribe('Environment', {environment_id}).then ->
					environment = Environment.db.findOne(environment_id)
					deferred.resolve(environment) if environment?
					deferred.reject('Environment could not be found') unless environment?
				return deferred.promise
			]
			'application': ['$meteor', '$q', 'environment', ($meteor, $q, environment) -> 
				deferred = $q.defer()
				application_id = environment['application_id']
				$meteor.subscribe('Application', application_id).then ->
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
					$meteor.subscribe('DocumentSchema', {blueprint_id})
					$meteor.subscribe('ScreenSchema', {blueprint_id})
				]).then ->
					blueprint = Blueprint.db.findOne(blueprint_id)
					deferred.resolve(blueprint) if blueprint?
					deferred.reject('Blueprint could not be found') unless blueprint?
				return deferred.promise
			]

	.state 'application.screen',
		url: '/screen/:screen_schema_id'
		templateUrl: 'client/views/application-screen.template.html'
		controller: 'ApplicationScreenCtrl'
		resolve:
			'screenSchema': ['$meteor', '$q', '$stateParams', ($meteor, $q, $stateParams) -> 
				deferred = $q.defer()
				screen_schema_id = $stateParams.screen_schema_id
				$meteor.subscribe('ScreenSchema', {screen_schema_id}).then ->
					screenSchema = ScreenSchema.db.findOne(screen_schema_id)
					ScreenSchema.buildWidgetHierarchy(screenSchema)
					deferred.resolve(screenSchema) if screenSchema?
					deferred.reject('ScreenSchema could not be found') unless screenSchema?
				return deferred.promise
			]
])