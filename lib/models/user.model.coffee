@User = 

	db: Meteor.users

	ROLE:
		'Owner': 	{value: 'owner'}
		'User': 	{value: 'user'}

	canEditApplication: ({user, application_id}) ->
		return true if _.some(user['profile']['application_roles'], {'application_id': application_id, 'can_edit': true})
		return false

	hasApplicationRole: ({user, application, role}) ->
		application_id = application['_id']
		return _.some(user['profile']['application_roles'], {application_id, role})

	isApplicationOwner: ({user, application}) ->
		role = User.ROLE['Owner'].value
		return @hasApplicationRole({user, application, role})