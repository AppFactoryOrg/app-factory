Meteor.methods
	'DocumentSchema.create': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(Meteor.userId(), parameters['blueprint_id'], true)
		throw new Meteor.Error('validation', 'Parameters object is required') unless parameters?
		throw new Meteor.Error('validation', 'Parameter "name" is required') if _.isEmpty(parameters['name'])
		throw new Meteor.Error('validation', 'Parameter "blueprint_id" is required') if _.isEmpty(parameters['blueprint_id'])

		blueprint = Blueprint.db.findOne(parameters['blueprint_id'])
		throw new Meteor.Error('validation', 'Cannot find Blueprint') unless blueprint?
		throw new Meteor.Error('validation', 'Blueprint is not in "Draft" status') unless blueprint.status is Blueprint.STATUS['Draft'].value

		documentSchema = DocumentSchema.new()
		documentSchema['name'] = parameters['name']
		documentSchema['abbreviation'] = parameters['name'].substring(0, 2).toUpperCase()
		documentSchema['description'] = parameters['description']
		documentSchema['blueprint_id'] = blueprint['_id']
		documentSchema['_id'] = DocumentSchema.db.insert(documentSchema)

		return documentSchema['_id']

	'DocumentSchema.update': (parameters) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(Meteor.userId(), parameters['blueprint_id'], true)
		throw new Meteor.Error('validation', 'Parameters object is required') unless parameters?
		throw new Meteor.Error('validation', 'Document has too many attributes') if parameters['attributes'].length > Config['MAX_ATTRIBUTES_COUNT']

		documentSchema = DocumentSchema.db.findOne(parameters['_id'])
		throw new Meteor.Error('validation', 'Cannot find Document') unless documentSchema?

		updates = _.pick(parameters, DocumentSchema.MUTABLE_PROPERTIES)

		# Stringify view filter and sort presets, because Mongo can't handle . or $ in keys
		if updates['views']?
			updates['views'].forEach (view) ->
				view['filter'] = JSON.stringify(view['filter'])
				view['sort'] = JSON.stringify(view['sort'])
				view['limits'] = JSON.stringify(view['limits'])

		DocumentSchema.db.update({'_id': documentSchema['_id']}, {$set: updates})

		return documentSchema['_id']

	'DocumentSchema.delete': (id) ->
		throw new Meteor.Error('security', 'Unauthorized') unless Meteor.user()?
		throw new Meteor.Error('validation', 'Id is required') unless id?

		documentSchema = DocumentSchema.db.findOne(id)
		throw new Meteor.Error('validation', 'Cannot find Document') unless documentSchema?
		throw new Meteor.Error('security', 'Unauthorized') unless User.canAccessBlueprint(Meteor.userId(), documentSchema['blueprint_id'], true)

		DocumentSchema.db.remove(id)

		return
