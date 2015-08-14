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

	'Limits.canCreateDocument': (application_id, document) ->
		throw new Meteor.Error('validation', 'Application not specified') unless application_id?
		throw new Meteor.Error('validation', 'Document not specified') unless document?

		application = Application.db.findOne(application_id)
		throw new Meteor.Error('data', 'Application could not be found') unless application?

		current_db_bytes = application['metadata']['db_size']['value']
		max_bytes = application['limits']['max_db'] * 1024 * 1024
		additional_bytes = document['size']

		if current_db_bytes + additional_bytes <= max_bytes
			return true
		else
			return false

	'Limits.canUpdateDocument': (application_id, document, updates) ->
		throw new Meteor.Error('validation', 'Application not specified') unless application_id?
		throw new Meteor.Error('validation', 'Document not specified') unless document?
		throw new Meteor.Error('validation', 'Updates not specified') unless updates?

		application = Application.db.findOne(application_id)
		throw new Meteor.Error('data', 'Application could not be found') unless application?

		current_db_bytes = application['metadata']['db_size']['value']
		max_bytes = application['limits']['max_db'] * 1024 * 1024

		old_length = JSON.stringify(document).length
		new_length = JSON.stringify(_.assign(document, updates)).length

		additional_bytes = new_length - old_length

		if current_db_bytes + additional_bytes <= max_bytes
			return true
		else
			return false
