Meteor.methods
	'Limits.canInviteUser': (application_id) ->
		throw new Meteor.Error('validation', 'Application not specified') unless application_id?

		application = Application.db.findOne(application_id)
		throw new Meteor.Error('data', 'Application could not be found') unless application?

		current_users = application['metadata']['user_count']['value']
		max_users = application['limits']['max_users']

		if current_users + 1 <= max_users
			return true
		else
			return false
