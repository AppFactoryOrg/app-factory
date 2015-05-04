angular.module('app-factory').controller('AccountCtrl', ['$scope', '$meteor', '$state', ($scope, $meteor, $state) ->

	$scope.logout = ->
		$meteor.logout()
		$state.go('login')

])