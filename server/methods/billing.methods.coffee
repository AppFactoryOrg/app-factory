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
		return unless Meteor.settings.public.stripe_is_enabled

		user = User.db.findOne(Meteor.userId())
		throw new Meteor.Error('data', 'Cannot find user') unless user?

		stripe_customer_id = user['billing_profile']['stripe_customer_id']
		throw new Meteor.Error('data', 'User does not have a stripe id') unless stripe_customer_id?

		promise = new Future

		onCustomerRetrieved = Meteor.bindEnvironment (error, customer) ->
			throw new Meteor.Error('third-party', 'We were not able to retrieve your billing information. Please contact support.') if error

			credit_card = _.findWhere(customer['sources']['data'], {id: customer['default_source']})
			credit_card = _.pick(credit_card, ['last4', 'exp_month', 'exp_year', 'brand']) if credit_card?

			user_info =
				'credit_card': credit_card
				'applications': []

			promise.return(user_info)

		Stripe.customers.retrieve(stripe_customer_id, onCustomerRetrieved)

		return promise.wait()

	'Billing.updateCreditCard': (token) -> Utils.logErrors ->
		throw new Meteor.Error('validation', 'Token is required') unless token?
		return unless Meteor.settings.public.stripe_is_enabled

		user = User.db.findOne(Meteor.userId())
		throw new Meteor.Error('data', 'Cannot find user') unless user?

		stripe_customer_id = user['billing_profile']['stripe_customer_id']
		throw new Meteor.Error('data', 'User does not have a stripe id') unless stripe_customer_id?

		promise = new Future

		onCustomerUpdated = Meteor.bindEnvironment (error, customer) ->
			throw new Meteor.Error('third-party', 'We were not able to update your credit card. Please contact support.') if error
			promise.return()

		Stripe.customers.update(stripe_customer_id, {source: token}, onCustomerUpdated)

		return promise.wait()
