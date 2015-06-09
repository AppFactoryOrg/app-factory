angular.module('app-factory').factory('UserUtils', ['$meteor', '$q', ($meteor, $q) ->
	getById: (user_id) -> $q (resolve, reject) ->
		unless user_id?
			reject()
			return

		user = User.db.findOne(user_id)
		if user?
			resolve({user})
		else
			console.warn('User not found, fetching...')
			$meteor.subscribe('User', {user_id}).then ->
				user = User.db.findOne(user_id)
				if user?
					resolve({user})
				else
					console.warn('User not found, even after fetching.')
					reject()

	getUserName: (user_id) -> $q (resolve, reject) =>
		@getById(user_id)
			.then ({user}) ->
				resolve(user['profile']['name'])
			.catch ->
				reject()
])