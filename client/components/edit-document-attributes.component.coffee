angular.module('app-factory').directive('afEditDocumentAttributes', ['$compile', ($compile) ->
	restrict: 'E'
	templateUrl: 'client/templates/edit-document-attributes.template.html'
	scope:
		'document': 		'='
		'documentSchema': 	'='
		'onSubmit': 		'&'
	link: ($scope, $element) ->

		$scope.initializeAttributes = ->
			$scope.documentSchema['attributes'].forEach (attributes, index) ->
				name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': attributes['data_type']).component
				childTemplate = "
					<af-attribute-input-#{name} 
						attribute='documentSchema.attributes[#{index}]'
						document='document'>
					</af-attribute-input-#{name}>
				"
				attributesEl = $('.attributes', $element)
				attributesEl.append(childTemplate)
				$compile(attributesEl)($scope)

		# Initialize
		$scope.initializeAttributes()

])