Future = Npm.require('fibers/future')

if Meteor.settings.public.billing_is_enabled
	Stripe = StripeAPI(Meteor.settings.private.stripe_secret_key)

Meteor.methods
	'Billing.getCustomerId': ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?

		user = User.db.findOne(Meteor.userId())
		throw new Meteor.Error('data', 'Cannot find user') unless user?

		customer_id = user['billing_profile']?['stripe_customer_id']
		throw new Meteor.Error('data', 'User does not have a customer id') unless customer_id?

		return customer_id

	'Billing.createCustomer': (user) ->
		return unless Meteor.settings.public.billing_is_enabled
		throw new Meteor.Error('validation', 'User is required') unless user?

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

	'Billing.getUserInfo': ->
		return unless Meteor.settings.public.billing_is_enabled
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?

		customer_id = Meteor.call('Billing.getCustomerId')

		user_info = {}
		user_info['credit_card'] = Meteor.call('Billing.getCustomerCreditCard', customer_id)
		user_info['plans'] = Meteor.call('Billing.getCustomerPlans', customer_id)
		user_info['applications'] = User.getOwnedApplications(Meteor.user())
		user_info['subscriptions'] = []

		subscriptions = Meteor.call('Billing.getCustomerSubscriptions', customer_id)
		subscriptions.forEach (subscription) ->
			sub = _.pick(subscription, ['id', 'quantity', 'metadata'])
			sub['plan'] = _.pick(subscription['plan'], ['id', 'name', 'amount', 'metadata'])
			user_info['subscriptions'].push(sub)

		return user_info

	'Billing.getCustomerCreditCard': (customer_id) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?

		promise = new Future

		onCustomerRetrieved = Meteor.bindEnvironment (error, customer) ->
			throw new Meteor.Error('third-party', 'We were not able to retrieve your billing information. Please contact support.') if error

			credit_card = _.findWhere(customer['sources']['data'], {'id': customer['default_source']})
			credit_card = _.pick(credit_card, ['last4', 'exp_month', 'exp_year', 'brand']) if credit_card?

			promise.return(credit_card)

		Stripe.customers.retrieve(customer_id, onCustomerRetrieved)

		return promise.wait()

	'Billing.getCustomerPlans': (customer_id) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?

		promise = new Future

		onPlansRetrieved = Meteor.bindEnvironment (error, response) ->
			throw new Meteor.Error('third-party', 'We were not able to retrieve your billing information. Please contact support.') if error

			plans = response['data']
			promise.return(plans)

		Stripe.plans.list({limit: 100}, onPlansRetrieved)

		return promise.wait()

	'Billing.getCustomerSubscriptions': (customer_id) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?

		promise = new Future

		onSubscriptionsRetrieved = Meteor.bindEnvironment (error, response) ->
			throw new Meteor.Error('third-party', 'We were not able to retrieve your billing information. Please contact support.') if error

			subscriptions = response['data']
			subscriptions = _.filter(subscriptions, {'status': 'active'})

			promise.return(subscriptions)

		Stripe.customers.listSubscriptions(customer_id, onSubscriptionsRetrieved)

		return promise.wait()

	'Billing.updateCreditCard': (token) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Token is required') unless token?
		return unless Meteor.settings.public.billing_is_enabled

		customer_id = Meteor.call('Billing.getCustomerId')

		promise = new Future

		onCustomerUpdated = Meteor.bindEnvironment (error, customer) ->
			throw new Meteor.Error('third-party', 'We were not able to update your credit card. Please contact support.') if error
			promise.return()

		Stripe.customers.update(customer_id, {source: token}, onCustomerUpdated)

		return promise.wait()

	'Billing.updateApplicationSubscriptions': ({application_id, subscriptions}) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Application not specified') unless application_id?
		throw new Meteor.Error('validation', 'Subscriptions not specified') unless _.isArray(subscriptions) and not _.isEmpty(subscriptions)
		throw new Meteor.Error('validation', 'Invalid number of subscriptions specified') if subscriptions.length isnt 3

		billing_info = Meteor.call('Billing.getUserInfo')

		subscriptions.forEach (sub) ->
			plan = _.findWhere(billing_info['plans'], {'id': sub['plan']['id']})
			throw new Meteor.Error('validation', 'Cannot find Plan for Subscription') unless plan?
			sub['plan'] = plan

		application = Application.db.findOne(application_id)
		throw new Meteor.Error('validation', 'Cannot find Application') unless application?

		if not billing_info['credit_card']?
			active_subscriptions = _.filter(subscriptions, (sub) -> parseInt(sub['quantity']) > 0 and sub['plan']['id'] isnt 'free')
			if not _.isEmpty(active_subscriptions)
				throw new Meteor.Error('validaiton', 'A valid credit card is required to work with paid plans.')

		main_subscription = _.find(subscriptions, (sub) -> sub['plan']['metadata']['type'] is 'main')
		throw new Meteor.Error('validation', 'A main subscription was not specified') unless main_subscription?

		user_subscription = _.find(subscriptions, (sub) -> sub['plan']['metadata']['type'] is 'users')
		throw new Meteor.Error('validation', 'A user subscription was not specified') unless user_subscription?

		database_subscription = _.find(subscriptions, (sub) -> sub['plan']['metadata']['type'] is 'database')
		throw new Meteor.Error('validation', 'A database subscription was not specified') unless database_subscription?

		if Meteor.settings.public.application_limits.should_enforce
			base_users = parseInt(main_subscription['plan']['metadata']['base_users'])
			users_per_quantity = parseInt(user_subscription['plan']['metadata']['users_per_quantity'])
			additional_user_quantity = parseInt(user_subscription['quantity'])
			max_users = base_users + (additional_user_quantity * users_per_quantity)

			if application['metadata']['user_count']['value'] > max_users
				throw new Meteor.Error('validation', 'Application has more users than the subscription allows')

			base_mb = parseInt(main_subscription['plan']['metadata']['base_mb'])
			mb_per_quantity = parseInt(database_subscription['plan']['metadata']['mb_per_quantity'])
			additional_mb_quantity = parseInt(database_subscription['quantity'])
			max_db = base_mb + (additional_mb_quantity * mb_per_quantity)

			if application['metadata']['db_size']['value'] > (max_db*1024*1024)
				throw new Meteor.Error('validation', 'Application uses more database MB than the subscription allows')

		subscriptions.forEach (new_subscription) ->
			old_subscription = _.find(billing_info['subscriptions'], (other_sub) ->
				return false unless other_sub['metadata']['application_id'] is application_id
				return false unless other_sub['plan']['metadata']['type'] is new_subscription['plan']['metadata']['type']
				return true
			)

			if old_subscription?
				different_plan = new_subscription['plan']['id'] isnt old_subscription['plan']['id']
				different_quantity = new_subscription['quantity'] isnt old_subscription['quantity']
				return unless different_plan or different_quantity

				subscription = new_subscription
				subscription['id'] = old_subscription['id']
				Meteor.call('Billing.updateSubscription', ({application_id, subscription}))
				return
			else
				subscription = new_subscription
				Meteor.call('Billing.createSubscription', ({application_id, subscription}))
				return

		if Meteor.settings.public.application_limits.should_enforce
			Application.db.update(application_id, {
				$set: {
					'limits.max_users': max_users
					'limits.max_db': max_db
				}
			})

		return

	'Billing.createSubscription': ({application_id, subscription}) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Application not specified') unless application_id?
		throw new Meteor.Error('validation', 'Subscription not specified') unless subscription?

		customer_id = Meteor.call('Billing.getCustomerId')

		sub_params =
			'plan': subscription['plan']['id']
			'quantity': subscription['quantity']
			'metadata':
				'application_id': application_id

		promise = new Future

		onSubscriptionCreated = Meteor.bindEnvironment (error, subscription) ->
			throw new Meteor.Error('third-party', 'We were not able to update billing information. Please contact support.') if error
			promise.return()

		Stripe.customers.createSubscription(customer_id, sub_params, onSubscriptionCreated)

		return promise.wait()

	'Billing.updateSubscription': ({application_id, subscription}) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?

		throw new Meteor.Error('validation', 'Application not specified') unless application_id?
		throw new Meteor.Error('validation', 'Subscription not specified') unless subscription?

		customer_id = Meteor.call('Billing.getCustomerId')

		sub_params =
			'plan': subscription['plan']['id']
			'quantity': subscription['quantity']
			'metadata':
				'application_id': application_id

		promise = new Future

		onSubscriptionUpdated = Meteor.bindEnvironment (error, subscription) ->
			throw new Meteor.Error('third-party', 'We were not able to update billing information. Please contact support.') if error
			promise.return()

		Stripe.customers.updateSubscription(customer_id, subscription['id'], sub_params, onSubscriptionUpdated)

		return promise.wait()
