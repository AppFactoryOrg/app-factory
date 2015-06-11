angular.module('app-factory').controller('CommonAttributeValueCtrl', ['$scope', '$q', '$meteor', ($scope, $q, $meteor) ->
	
	$scope.getValue = -> $q (resolve, reject) ->
		switch $scope.attribute['value_type']
			when DocumentAttribute.VALUE_TYPE['Input'].value
				value = $scope.document['data'][$scope.attribute['id']]
				resolve(value)

			when DocumentAttribute.VALUE_TYPE['Routine'].value
				id = $scope.attribute['routine_id']
				inputs = [
					{
						'name': 'document'
						'value': $scope.document
					}
				]
				$meteor.call('Routine.execute', {id, inputs})
					.then (output) ->
						resolve(output)
					.catch (error) ->
						reject(error)
])