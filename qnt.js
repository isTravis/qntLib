// Generated by CoffeeScript 1.6.3
/* Copyright (c) 2014 MIT Media Lab, https://qnt.io*/


(function() {
  var quantifyObject;

  quantifyObject = {
    _version: "0.0.1",
    _key: "ASCASS",
    _project: "",
    init: function(projectName, key) {
      this._project = projectName;
      this._key = key;
    },
    getKey: function() {
      return this._key;
    },
    getVersion: function() {
      return this._version;
    },
    getProjectName: function() {
      return this._project;
    },
    getContestents: function() {},
    getAccount: function() {},
    setAccount: function() {},
    vote: function() {},
    getSearchResults: function() {},
    getResults: function() {},
    _quantifyHTTP: function() {}
  };

  window.qnt = quantifyObject;

  console.log("Ran");

}).call(this);
