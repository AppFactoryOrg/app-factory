angular.module('app-factory').directive('afServiceValueConfiguration', ['$compile', '$meteor', '$timeout', ($compile, $meteor, $timeout) ->
	restrict: 'E'
	templateUrl: 'client/components/services/value/service-value-configuration.template.html'
	scope:
		'service': 	'='
	link: ($scope, $element) ->
		$scope.dataTypes = Utils.mapToArray(DocumentAttribute.DATA_TYPE)
		$scope.documentSchemas = $meteor.collection -> DocumentSchema.db.find()

		$scope.typeUpdated = ->
			return unless $scope.service?
			unless $scope.showDocumentSelection()
				$scope.service['configuration']['document_schema_id'] = null

			if $scope.showValue()
				$timeout -> $scope.initializeValueInput()
			else
				$scope.service['configuration']['value'] = null
				$timeout -> $scope.clearValueInput()

		$scope.showDocumentSelection =  ->
			return unless $scope.service?
			switch $scope.service['configuration']['data_type']
				when DocumentAttribute.DATA_TYPE['Document'].value
					return true
				when DocumentAttribute.DATA_TYPE['Collection'].value
					return true
				else
					return false
			
			return false

		$scope.showValue =  ->
			return unless $scope.service?
			return false unless $scope.service['configuration']['data_type']?
			switch $scope.service['configuration']['data_type']
				when DocumentAttribute.DATA_TYPE['Document'].value
					return $scope.service['configuration']['document_schema_id']?
				when DocumentAttribute.DATA_TYPE['Collection'].value
					return $scope.service['configuration']['document_schema_id']?
				else
					return true
			
			return false

		$scope.initializeValueInput = ->
			return unless $scope.service?
			type = $scope.service['configuration']['data_type']
			name = _.findWhere(DocumentAttribute.DATA_TYPE, value: type).component
			childTemplate = "
				<af-attribute-#{name}-input 
					attribute=''
					document=''>
				</af-attribute-#{name}-input >
			"
			attributesEl = $('.service-value', $element)
			attributesEl.empty()
			attributesEl.append(childTemplate)
			$compile(attributesEl)($scope)

		$scope.clearValueInput = ->
			$('.service-value', $element).empty()

		# Initialize
		$scope.typeUpdated()
])