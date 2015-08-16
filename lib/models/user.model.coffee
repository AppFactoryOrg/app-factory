@User =

	db: Meteor.users

	ROLE:
		'Owner': 	{value: 'owner'}
		'User': 	{value: 'user'}

	canAccessApplication: (user_id, application_id) ->
		return false unless user_id? and application_id?
		user = User.db.findOne(user_id)
		return false unless user?
		return true if _.some(user['profile']['application_roles'], {'application_id': application_id})
		return false

	canAccessEnvironment: (user_id, environment_id) ->
		return false unless user_id? and environment_id?
		user = User.db.findOne(user_id)
		return false unless user?
		environment = Environment.db.findOne(environment_id)
		return false unless environment?
		return true if _.some(user['profile']['application_roles'], {'application_id': environment['application_id']})
		return false

	canAccessBlueprint: (user_id, blueprint_id) ->
		return false unless user_id? and blueprint_id?
		user = User.db.findOne(user_id)
		return false unless user?
		blueprint = Blueprint.db.findOne(blueprint_id)
		return false unless blueprint?
		return true if _.some(user['profile']['application_roles'], {'application_id': blueprint['application_id']})
		return false

	canEditApplication: (user_id, application_id) ->
		return false unless user_id? and application_id?
		user = User.db.findOne(user_id)
		return false unless user?
		return true if _.some(user['profile']['application_roles'], {'application_id': application_id, 'can_edit': true})
		return false

	hasApplicationRole: ({user, application, role}) ->
		return false unless user? and application? and role?
		application_id = application['_id']
		return _.some(user['profile']['application_roles'], {application_id, role})

	isApplicationOwner: ({user, application}) ->
		return false unless user? and application?
		role = User.ROLE['Owner'].value
		return @hasApplicationRole({user, application, role})

	getOwnedApplications: (user)->
		owned_application_ids = _.pluck(_.filter(user['profile']['application_roles'], {'role': User.ROLE['Owner'].value}), 'application_id')
		applications = Application.db.find({'_id': {$in: owned_application_ids}}).fetch()
		return applications
