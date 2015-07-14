Accounts.validateLoginAttempt (attempt) ->
	return false unless attempt.user?

	throw new Meteor.Error('limitation', 'Your account has been disabled. Contact your hosting administrator for more information.') if attempt.user['profile']['disabled'] is true

	return true
