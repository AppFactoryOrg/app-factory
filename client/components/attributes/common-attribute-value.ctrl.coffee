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
						'name': 'Document'
						'value': $scope.document
					}
				]
				$meteor.call('Routine.execute', {id, inputs})
					.then (outputs) ->
						reject("Routine output is not an valid") unless _.isArray(outputs) and not _.isEmpty(outputs)
						output = outputs[0]['value']
						resolve(output)
					.catch (error) ->
						reject(error)
])