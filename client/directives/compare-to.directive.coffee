angular.module('app-factory').directive 'compareTo', ->
	require: "ngModel"
	scope:
		otherModelValue: "=compareTo"
	link: (scope, element, attributes, ngModel) ->

		ngModel.$validators.compareTo = (modelValue) ->
			return modelValue is scope.otherModelValue

		scope.$watch "otherModelValue", ->
			ngModel.$validate()
