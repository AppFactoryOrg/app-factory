@User =

	db: Meteor.users

	ROLE:
		'Owner': 	{value: 'owner'}
		'User': 	{value: 'user'}

	canAccessApplication: (user_id, application_id, can_edit) ->
		return false unless user_id? and application_id?
		user = User.db.findOne(user_id)
		return false unless user?
		role_params = {}
		role_params['application_id'] = application_id
		role_params['can_edit'] = true if can_edit
		return true if @hasApplicationRole(user, role_params)
		return false

	canAccessEnvironment: (user_id, environment_id, can_edit) ->
		return false unless user_id? and environment_id?
		user = User.db.findOne(user_id)
		return false unless user?
		environment = Environment.db.findOne(environment_id)
		return false unless environment?
		role_params = {}
		role_params['application_id'] = environment['application_id']
		role_params['can_edit'] = true if can_edit
		return true if @hasApplicationRole(user, role_params)
		return false

	canAccessBlueprint: (user_id, blueprint_id, can_edit) ->
		return false unless user_id? and blueprint_id?
		user = User.db.findOne(user_id)
		return false unless user?
		blueprint = Blueprint.db.findOne(blueprint_id)
		return false unless blueprint?
		role_params = {}
		role_params['application_id'] = blueprint['application_id']
		role_params['can_edit'] = true if can_edit
		return true if @hasApplicationRole(user, role_params)
		return false

	hasApplicationRole: (user, parameters) ->
		return false unless user? and parameters?
		return _.some(user['profile']['application_roles'], parameters)

	isApplicationOwner: ({user, application}) ->
		return false unless user? and application?
		role_params = {}
		role_params['application_id'] = application['_id']
		role_params['role'] = User.ROLE['Owner'].value
		return @hasApplicationRole(user, role_params)

	getOwnedApplicationIds: (user) ->
		return _.pluck(_.filter(user['profile']['application_roles'], {'role': User.ROLE['Owner'].value}), 'application_id')

	getOwnedApplications: (user)->
		owned_application_ids = User.getOwnedApplicationIds(user)
		applications = Application.db.find({'_id': {$in: owned_application_ids}}).fetch()
		return applications
