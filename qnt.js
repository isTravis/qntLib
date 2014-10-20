// Generated by CoffeeScript 1.8.0

/* Copyright (c) 2014 MIT Media Lab, https://qnt.io */

(function() {
  var checkLocalCookie, getAccountName, getQueryString, quantifyObject,
    __slice = [].slice;

  getQueryString = function(obj) {
    var k, s, v;
    s = [];
    for (k in obj) {
      v = obj[k];
      if (v) {
        s.push(encodeURIComponent(k) + "=" + encodeURIComponent(v));
      }
    }
    return s.join("&");
  };

  checkLocalCookie = function() {
    var c, ca, i, name;
    name = "qnt_uID=";
    ca = document.cookie.split(";");
    i = 0;
    while (i < ca.length) {
      c = ca[i];
      while (c.charAt(0) === " ") {
        c = c.substring(1);
      }
      if (c.indexOf(name) !== -1) {
        return c.substring(name.length, c.length);
      }
      i++;
    }
    return "";
  };

  getAccountName = function() {};

  quantifyObject = {
    _version: "0.0.1",
    _base_url: "https://www.qnt.io/api",
    _project: "",
    _key: "key",
    _user: "",
    init: function(projectName, key, callback) {
      this._project = projectName;
      this._key = key;
      this._quantifyHTTP("get", "checkusercookie", {}, function(checkCookieResult) {
        if (checkCookieResult[0]['uID']) {
          qnt._user = checkCookieResult[0]['uID'];
          return callback();
        } else if (checkLocalCookie()) {
          qnt._user = checkLocalCookie();
          return callback();
        } else {
          console.log("No cookie found. Creating new user");
          return qnt._quantifyHTTP("post", "createuser", {}, function(e) {
            qnt._user = e['uID'];
            if ((navigator.userAgent.search("Safari") >= 0 && navigator.userAgent.search("Chrome") < 0) || navigator.userAgent.match(/(iPad|iPhone|iPod touch);.*CPU.*OS 7_\d/i)) {
              document.cookie = "qnt_uID=" + e["uID"] + "; expires=Tue, 15 Nov 2050 12:00:00 UTC";
            }
            return callback();
          });
        }
      });
    },
    getKey: function() {
      return this._key;
    },
    getVersion: function() {
      return this._version;
    },
    getUser: function() {
      return this._user;
    },
    getProjectName: function() {
      return this._project;
    },
    setAccount: function(user) {
      if (validatedUser(user)) {
        this._user = user;
        return true;
      } else {
        return false;
      }
    },
    getContent: function(cID, callback) {
      var data;
      data = {
        cID: cID
      };
      return this._quantifyHTTP("get", "content", data, callback);
    },
    getScores: function(cID, callback) {
      var data;
      data = {
        cID: cID
      };
      return this._quantifyHTTP("get", "scores", data, callback);
    },
    getSearchResults: function() {
      var callback, data, limit, mID, metric_score, skip, _arg, _i;
      mID = arguments[0], metric_score = arguments[1], _arg = 4 <= arguments.length ? __slice.call(arguments, 2, _i = arguments.length - 1) : (_i = 2, []), callback = arguments[_i++];
      skip = _arg[0], limit = _arg[1];
      data = {
        mID: mID,
        metric_score: metric_score,
        skip: skip,
        limit: limit
      };
      return this._quantifyHTTP("get", "search", data, callback);
    },
    getMetrics: function(mID) {
      var data;
      data = {
        mID: mID
      };
      return this._quantifyHTTP("get", "metric", data, callback);
    },
    vote: function() {
      var callback, data, mID, uID, vote_data, vote_result, voter_ip, _arg, _i;
      mID = arguments[0], vote_data = arguments[1], uID = arguments[2], vote_result = arguments[3], _arg = 6 <= arguments.length ? __slice.call(arguments, 4, _i = arguments.length - 1) : (_i = 4, []), callback = arguments[_i++];
      voter_ip = _arg[0];
      data = {
        mID: mID,
        uID: uID,
        vote_data: vote_data,
        vote_result: vote_result,
        voter_ip: voter_ip
      };
      return this._quantifyHTTP("post", "vote", data, callback);
    },
    getContestants: function() {
      var callback, data, mID, mode, num_desired_contestants, _arg, _i;
      mID = arguments[0], mode = arguments[1], _arg = 4 <= arguments.length ? __slice.call(arguments, 2, _i = arguments.length - 1) : (_i = 2, []), callback = arguments[_i++];
      num_desired_contestants = _arg[0];
      data = {
        mID: mID,
        mode: mode,
        num_desired_contestants: num_desired_contestants
      };
      return this._quantifyHTTP("get", "contestants", data, callback);
    },
    getResults: function() {
      var callback, data, limit, mID, skip, sort, _arg, _i;
      mID = arguments[0], _arg = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
      skip = _arg[0], limit = _arg[1], sort = _arg[2];
      data = {
        mID: mID,
        sort: sort,
        skip: skip,
        limit: limit
      };
      return this._quantifyHTTP("get", "results", data, callback);
    },
    getDisplayMetrics: function() {
      var callback, data, limit, mode, _arg, _i;
      mode = arguments[0], _arg = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
      limit = _arg[0];
      data = {
        mode: mode,
        limit: limit
      };
      return this._quantifyHTTP("get", "displaymetrics", data, callback);
    },
    getProjectStats: function(callback) {
      return this._quantifyHTTP("get", "projectstats", {}, callback);
    },
    getUserData: function(uID, callback) {
      var data;
      data = {
        uID: uID
      };
      return this._quantifyHTTP("get", "userdata", data, callback);
    },
    addUserData: function(user_data, callback) {
      var data;
      data = {
        uID: this._user,
        user_data: user_data
      };
      return this._quantifyHTTP("post", "userdata", data, callback);
    },
    _quantifyHTTP: function(method, entity, data, callback) {
      var qntData, url, xhr;
      qntData = {
        pID: this._project,
        key: this._key
      };
      url = this._base_url + "/" + entity + "?" + getQueryString(data) + "&" + getQueryString(qntData);
      xhr = new XMLHttpRequest();
      xhr.overrideMimeType("application/json");
      xhr.withCredentials = true;
      xhr.onload = function(resp) {
        return callback(JSON.parse(resp.target.responseText));
      };
      xhr.open(method, url, true);
      return xhr.send();
    }
  };

  window.qnt = quantifyObject;

  console.log("Quantify Library Launched");

}).call(this);
