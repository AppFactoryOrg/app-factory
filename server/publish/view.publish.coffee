Meteor.publish 'View', ({view_id, blueprint_id}) ->
	# TODO: Check user's permissions
	if view_id
		return View.db.find('_id': view_id)
	else
		return View.db.find('blueprint_id': blueprint_id)