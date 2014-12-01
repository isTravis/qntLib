### Copyright (c) 2014 MIT Media Lab, https://qnt.io ###

# TODO Use encodeURIComponent?
getQueryString = (obj) ->
    s = []
    for k, v of obj
        if v
            if typeof v == "string"
                if String(v).split(",").length>1 and v.split("{").length < 2# If we have a comma separated string of values, but it's not an object -i.e. not a userData upload...
                    j = 0
                    while j < v.split(",").length
                      s.push encodeURIComponent(k) + "=" + encodeURIComponent(v.split(",")[j])
                      j++
                else # If it's just a single value...
                    s.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
            else # If it's just a single value...
                s.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
    s.join("&")



checkLocalCookie = ->
  name = "qnt_uID="
  ca = document.cookie.split(";")
  i = 0

  while i < ca.length
    c = ca[i]
    c = c.substring(1)  while c.charAt(0) is " "
    return c.substring(name.length, c.length)  unless c.indexOf(name) is -1
    i++
  ""


getAccountName = () ->
    return

quantifyObject = 
    _version: "0.0.1"
    _base_url: "https://www.qnt.io/api"
    # _base_url: "http://localhost:5000/api"
    _project: ""    
    _key: "key"
    _user: ""
    
    

    init: (projectName, key, callback)->
        @_project = projectName
        @_key = key

        # Check for cookie
        @_quantifyHTTP("get", "checkusercookie", {}, (checkCookieResult)->
            
            if checkCookieResult[0]['uID'] # If it allows and has a cross-domain cookie (argh, Safari!), set user.
                qnt._user = checkCookieResult[0]['uID']
                return callback()

            else if checkLocalCookie() # If we don't have cross-domain, check for a local cookie
                qnt._user = checkLocalCookie()
                return callback()
                            
            else # Else, we didn't find a cookie, create a new username and then set current user. Set local cookie of Safari
                console.log "No cookie found. Creating new user"
                qnt._quantifyHTTP("post", "createuser", {}, (e)->
                    qnt._user=e['uID']
                    # For Safari, set a local cookie:
                    document.cookie = "qnt_uID=" + e["uID"] + "; expires=Tue, 15 Nov 2050 12:00:00 UTC"  if (navigator.userAgent.search("Safari") >= 0 and navigator.userAgent.search("Chrome") < 0) or navigator.userAgent.match(/(iPad|iPhone|iPod touch);.*CPU.*OS 7_\d/i)
                    return callback()
                )
            
        )
        return

    getKey: -> @_key
    getVersion: -> @_version
    getUser: -> @_user
    getProjectName: -> @_project

    # checkUserNameCookie: (callback) ->
    #     @_quantifyHTTP("get", "checkusercookie", {}, callback)

    # createUserName: (callback) ->
    #     @_quantifyHTTP("get", "createuser", {}, callback)

    setAccount: (user) -> 
        # TODO Validate user
        if validatedUser(user)
            @_user = user
            return true
        else
            return false

    getContent: (cID, callback) ->
        data = 
            cID: cID
        @_quantifyHTTP("get", "content", data, callback)

    getScores: (cID, callback) ->
        data = 
            cID: cID
        @_quantifyHTTP("get", "scores", data, callback)

    getScores_user: (uID, cID, callback) ->
        data = 
            uID: uID
            cID: cID
        @_quantifyHTTP("get", "user_scores", data, callback)

    getSearchResults: (mID, metric_score, [skip, limit]..., callback) -> 
        data = 
            mID: mID
            metric_score: metric_score
            skip: skip
            limit: limit
        @_quantifyHTTP("get", "search", data, callback)

    getSearchResults_user: (uID, mID, metric_score, [skip, limit]..., callback) -> 
        data = 
            uID: uID
            mID: mID
            metric_score: metric_score
            skip: skip
            limit: limit
        @_quantifyHTTP("get", "user_search", data, callback)

    getMetrics: (mID) ->
        data = 
            mID: mID
        @_quantifyHTTP("get", "metric", data, callback)

    vote: (mID, vote_data, uID, vote_result, [voter_ip]..., callback) -> 
        data = 
            mID: mID
            uID: uID
            vote_data: vote_data
            vote_result: vote_result
            voter_ip: voter_ip
        @_quantifyHTTP("post", "vote", data, callback)            

    getContestants: (mID, mode, [num_desired_contestants]..., callback) ->
        data = 
            mID: mID
            mode: mode
            num_desired_contestants: num_desired_contestants
        @_quantifyHTTP("get", "contestants", data, callback)

    getContestants_user: (uID, mID, mode, [num_desired_contestants]..., callback) ->
        data = 
            uID: uID
            mID: mID
            mode: mode
            num_desired_contestants: num_desired_contestants
        @_quantifyHTTP("get", "user_contestants", data, callback)

    getUserVotes: (uID, [limit]..., callback) ->
        if typeof limit isnt "undefined"
            data =
                uID: uID
                limit: limit.toString()
        else
            data = 
                uID:uID

        @_quantifyHTTP("get", "uservotes", data, callback)

    getResults: (mID, [skip, limit, sort]..., callback) ->
        data = 
            mID: mID
            sort: sort
            skip: skip
            limit: limit
        @_quantifyHTTP("get", "results", data, callback)

    getResults_user: (uID, mID, [skip, limit, sort]..., callback) ->
        data = 
            uID: uID
            mID: mID
            sort: sort
            skip: skip
            limit: limit
        @_quantifyHTTP("get", "user_results", data, callback)

    getDisplayMetrics: (mode, [limit]..., callback) -> 
        data =
            mode: mode
            limit: limit
        @_quantifyHTTP("get", "displaymetrics", data, callback)

    getProjectStats: (callback) -> 
        @_quantifyHTTP("get", "projectstats", {}, callback)

    getUserData: (uID, callback) ->
        data =
            uID: uID
        @_quantifyHTTP("get", "userdata", data, callback)

    addUserData: (user_data, callback) -> 
        data = 
            uID: @_user
            user_data: user_data
        @_quantifyHTTP("post", "userdata", data, callback)   

    buildScores: ([uID]...,callback) -> 
        data = 
            uID: uID
        @_quantifyHTTP("get", "buildscores", data, callback)   



    # Good code snippets here: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Using_XMLHttpRequest
    # HTTP Method abstracting the need to insert pID and key
    _quantifyHTTP: (method, entity, data, callback) -> 
        if method is 'post'
            qntData =
                pID: @_project
                key: @_key
            url = @_base_url + "/" + entity
            xhr = new XMLHttpRequest()
            xhr.overrideMimeType("application/json"); 
            xhr.withCredentials = true;
            xhr.onload = (resp) ->
              callback JSON.parse(resp.target.responseText)
            xhr.open(method, url, true)
            xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
            xhr.send(getQueryString(data) + "&" + getQueryString(qntData))
        else
            qntData =
                pID: @_project
                key: @_key
            url = @_base_url + "/" + entity + "?" + getQueryString(data) + "&" + getQueryString(qntData)
            xhr = new XMLHttpRequest()
            xhr.overrideMimeType("application/json"); 
            xhr.withCredentials = true;
            xhr.onload = (resp) ->
              callback JSON.parse(resp.target.responseText)
            xhr.open(method, url, true)
            xhr.send()



window.qnt = quantifyObject
console.log("Quantify Library Launched")

