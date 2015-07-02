Accounts.emailTemplates.siteName = "App Factory"
Accounts.emailTemplates.from = "App Factory <no-reply@app-factory.io>"

Accounts.emailTemplates.enrollAccount.subject = (user) ->
	return "Welcome to App Factory, " + user.profile.name

Accounts.emailTemplates.enrollAccount.text = (user, url) ->
	url = url.replace('#/enroll-account', 'enroll-account')
	return "To activate your account, click the link below:\n\n#{url}"

Accounts.emailTemplates.resetPassword.subject = (user) ->
	return "Reset your App Factory password"

Accounts.emailTemplates.resetPassword.text = (user, url) ->
	url = url.replace('#/reset-password', 'reset-password')
	return "To reset your password, click the link below:\n\n#{url}"