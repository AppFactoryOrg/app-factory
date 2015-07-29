Future = Npm.require('fibers/future')

if Meteor.settings.public.stripe_is_enabled
	Stripe = StripeAPI(Meteor.settings.private.stripe_secret_key)

Meteor.methods
	'Billing.createCustomer': (user) -> Utils.logErrors ->
		throw new Meteor.Error('validation', 'User is required') unless user?
		return unless Meteor.settings.public.stripe_is_enabled

		promise = new Future

		customer_params =
			'email': user['email']
			'description': user['profile']['name']

		onCustomerCreated = Meteor.bindEnvironment (error, customer) ->
			throw new Meteor.Error('third-party', 'We were not able to create your account. Please contact support.') if error

			User.db.update(user['_id'], {
				$set: {
					'billing_profile': {
						'stripe_customer_id': customer['id']
					}
				}
			})

			promise.return()

		Stripe.customers.create(customer_params, onCustomerCreated)

		return promise.wait()

	'Billing.getUserInfo': -> Utils.logErrors ->
		user_info =
			'credit_card': null
			'applications': []

		return user_info
