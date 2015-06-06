@User = 

	db: Meteor.users

	canEditApplication: ({user, application_id}) ->
		return true if _.some(user['profile']['application_roles'], {'application_id': application_id, 'can_edit': true})
		return false