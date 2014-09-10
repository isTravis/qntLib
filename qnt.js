// Copyright (c) 2014 MIT Media Lab, https://qnt.io

(function () {

	var qnt = {
		version: "0.0.1",
		key: "ASCASS",
		project: ""
	};

	qnt.init = function(project_name, key){
		qnt.project = project_name;
		qnt.key = key;
		return qnt;
	};

	window.qnt = qnt;
	console.log("Ran");

}());