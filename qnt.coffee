### Copyright (c) 2014 MIT Media Lab, https://qnt.io ###

quantifyObject = 
	_version: "0.0.1"
	_key: "ASCASS"
	_project: ""

	init: (projectName, key)->
		@_project = projectName
		@_key = key
		return

	getKey: -> @_key
	getVersion: -> @_version
	getProjectName: -> @_project
	getContestents: -> return
	getAccount: -> return
	setAccount: -> return
	vote: -> return
	getSearchResults: -> return
	getResults: -> return
	_quantifyHTTP: -> return

window.qnt = quantifyObject
console.log("Ran")