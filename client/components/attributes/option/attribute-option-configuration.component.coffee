angular.module('app-factory').directive('afAttributeOptionConfiguration', [() ->
	restrict: 'E'
	templateUrl: 'client/components/attributes/option/attribute-option-configuration.template.html'
	replace: true
	scope:
		'attribute': 	'='
	link: ($scope) ->
		$scope.newOption = null
		$scope.createdOptions = []
		$scope.shouldShowArchivedOptions = false
		$scope.sortableOptions =
			containment: '#attribute-sort-bounds'
			containerPositioning: 'relative'

		$scope.generateNewOption = ->
			$scope.newOption = 
				'id': Meteor.uuid()
				'name': ''
				'active': true

		$scope.addOption = ->
			$scope.attribute['configuration']['options'].push($scope.newOption)
			$scope.createdOptions.push($scope.newOption)
			$scope.generateNewOption()

		$scope.removeOption = (option) ->
			return unless confirm('Are you sure you want to remove this option?')
			if option in $scope.createdOptions
				Utils.removeFromArray(option, $scope.attribute['configuration']['options'])
			else
				option['active'] = false

		$scope.unarchiveOption = (option) ->
			option['active'] = true
			$scope.shouldShowArchivedOptions = false unless $scope.hasArchivedOptions()

		$scope.hasArchivedOptions = ->
			return _.some($scope.attribute['configuration']['options'], {'active': false})

		$scope.toggleArchivedOptions = ->
			$scope.shouldShowArchivedOptions = !$scope.shouldShowArchivedOptions

		# Initialize
		$scope.generateNewOption()
])