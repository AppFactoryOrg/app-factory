angular.module('app-factory').directive('afEditDocumentAttributes', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/edit-document-attributes.template.html'
	scope:
		'document': 		'='
		'documentSchema': 	'='
		'onSubmit': 		'&'
	link: ($scope, $element) ->

		$scope.initializeAttributes = ->
			$scope.documentSchema['attributes'].forEach (attribute, index) ->
				name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': attribute['data_type']).component
				childTemplate = "
					<af-attribute-#{name}-input 
						attribute='documentSchema.attributes[#{index}]'
						document='document'>
					</af-attribute-#{name}-input >
				"
				attributesEl = $('.attributes', $element)
				attributesEl.append(childTemplate)
				$compile(attributesEl)($scope)

		# Initialize
		$scope.initializeAttributes()

])