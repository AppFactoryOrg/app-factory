angular.module('app-factory').directive('autofocus', ['$timeout', ($timeout) ->
	restrict: 'A'
	link: ($scope, $element, $attrs) ->
		dom = $element[0]

		focus = (condition) ->
			if condition
				delay = $scope.$eval($attrs.focusDelay) or 0
				$timeout( ->
					dom.focus()
				, delay)

		if $attrs.autofocus
			$scope.$watch($attrs.autofocus, focus)
		else
			focus(true)
])
