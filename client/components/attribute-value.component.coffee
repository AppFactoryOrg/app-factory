angular.module('app-factory').directive('afAttributeValue', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/templates/attribute-value.template.html'
	scope:
		'attribute': 	'='
		'document': 	'='
	link: ($scope, $element) ->
		name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': $scope.attribute['data_type']).component
		childTemplate = "
			<af-attribute-value-#{name} 
				attribute='attribute'
				document='document'>
			</af-attribute-value-#{name}>
		"
		attributeEl = $('.attribute', $element)
		attributeEl.append(childTemplate)
		$compile(attributeEl)($scope)

])