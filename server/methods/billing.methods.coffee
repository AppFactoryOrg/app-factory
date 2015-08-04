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

		customer_id = user['billing_profile']['stripe_customer_id']
		throw new Meteor.Error('data', 'User does not have a customer id') unless customer_id?

		user_info = {}
		user_info['credit_card'] = Meteor.call('Billing.getCustomerCreditCard', customer_id)
		user_info['plans'] = Meteor.call('Billing.getCustomerPlans', customer_id)
		user_info['applications'] = []

		subscriptions = Meteor.call('Billing.getCustomerSubscriptions', customer_id)
		applications = User.getOwnedApplications(user)

		applications.forEach (application) ->
			application = _.pluck(application, ['_id', 'name'])
			main_subscription = _.findWhere(subscriptions, (sub) ->
				return false unless sub['metadata']['application_id'] is application['_id']
				return false unless sub['metadata']['is_main'] is true
				return true
			)

			if main_subscription?
				application['main_subscription'] = _.pluck(main_subscription, ['id', 'quantity'])
				application['main_subscription']['plan'] = _.pluck(main_subscription['plan'], ['id', 'name', 'amount'])
			else
				application['main_subscription'] = {'id': null, 'quantity': 0}
				application['main_subscription']['plan'] = {'id': 'free', 'name': 'Free', 'amount': 0}

			application['total_amount'] = 0
			application['total_amount'] = application['main_subscription']['quantity'] * application['main_subscription']['plan']['amount']

			user_info['applications'].push(application)

		user_info['total_amount'] = 0
		user_info['applications'].forEach (application) ->
			user_info['total_amount'] += application['total_amount']

		return user_info

	'Billing.getCustomerCreditCard': (customer_id) -> Utils.logErrors ->
		promise = new Future

		onCustomerRetrieved = Meteor.bindEnvironment (error, customer) ->
			throw new Meteor.Error('third-party', 'We were not able to retrieve your billing information. Please contact support.') if error

			credit_card = _.findWhere(customer['sources']['data'], {'id': customer['default_source']})
			credit_card = _.pick(credit_card, ['last4', 'exp_month', 'exp_year', 'brand']) if credit_card?

			promise.return(credit_card)

		Stripe.customers.retrieve(customer_id, onCustomerRetrieved)

		return promise.wait()

	'Billing.getCustomerPlans': (customer_id) -> Utils.logErrors ->
		promise = new Future

		onPlansRetrieved = Meteor.bindEnvironment (error, response) ->
			throw new Meteor.Error('third-party', 'We were not able to retrieve your billing information. Please contact support.') if error

			plans = response['data']
			promise.return(plans)

		Stripe.plans.list({limit: 100}, onPlansRetrieved)

		return promise.wait()

	'Billing.getCustomerSubscriptions': (customer_id) -> Utils.logErrors ->
		promise = new Future

		onSubscriptionsRetrieved = Meteor.bindEnvironment (error, response) ->
			throw new Meteor.Error('third-party', 'We were not able to retrieve your billing information. Please contact support.') if error

			subscriptions = response['data']
			subscriptions = _.filter(subscriptions, {'status': 'active'})

			promise.return(subscriptions)

		Stripe.customers.listSubscriptions(customer_id, onSubscriptionsRetrieved)

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
