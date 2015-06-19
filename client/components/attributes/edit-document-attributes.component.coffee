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
				return if attribute['value_type'] isnt DocumentAttribute.VALUE_TYPE['Input'].value
				name = _.findWhere(DocumentAttribute.DATA_TYPE, 'value': attribute['data_type']).component
				childTemplate = "
					<div class='form-group'>
						<label class='control-label col-lg-4' ng-bind='::documentSchema.attributes[#{index}].name'></label>
						<div class='col-lg-8'>
							<af-attribute-#{name}-input 
								object='document.data'
								key='documentSchema.attributes[#{index}].id'
								name='documentSchema.attributes[#{index}].name'
								config='documentSchema.attributes[#{index}].configuration'>
							</af-attribute-#{name}-input>
						</div>
					</div>
				"
				attributesEl = $('.attributes', $element)
				attributesEl.append(childTemplate)
				$compile(attributesEl)($scope)

		# Initialize
		$scope.initializeAttributes()

])