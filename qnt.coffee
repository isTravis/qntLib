### Copyright (c) 2014 MIT Media Lab, https://qnt.io ###

# TODO Use encodeURIComponent?
getQueryString = (obj) ->
    s = []
    for k, v of obj
        if v
            s.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
    s.join("&")


getAccountName = () ->
    return

quantifyObject = 
    _version: "0.0.1"
    _base_url: "https://www.qnt.io/api"
    # _base_url: "http://localhost:5000/api"
    _project: "earth_tapestry"    
    _key: "key"
    _user: ""
    
    

    init: (projectName, key)->
        @_project = projectName
        @_key = key

        # Check for cookie


        # console.log('in init')
        # @_quantifyHTTP("get", "user", data, (user) -> 
        #     console.log(result)
        #     @_user = result.user)
        return

    getKey: -> @_key
    getVersion: -> @_version
    getUser: -> @_user
    getProjectName: -> @_project

    checkUserNameCookie: (callback) ->
        @_quantifyHTTP("get", "checkusercookie", {}, callback)

    createUserName: (callback) ->
        @_quantifyHTTP("get", "createuser", {}, callback)

    setAccount: (user) -> 
        # TODO Validate user
        if validatedUser(user)
            @_user = user
            return true
        else
            return false

    getSearchResults: (mID, metric_score, [skip, limit]..., callback) -> 
        data = 
            mID: mID
            metric_score: metric_score
            skip: skip
            limit: limit
        @_quantifyHTTP("get", "search", data, callback)

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
            num_desired_contestants: num_desired_contestantso
        @_quantifyHTTP("get", "contestants", data, callback)

    getResults: (mID, [sort, skip, limit]..., callback) ->
        data = 
            mID: mID
            sort: sort
            skip: skip
            limit: limit
        @_quantifyHTTP("get", "results", data, callback)

    getDisplayMetrics: (mode, [limit]..., callback) -> 
        data =
            mode: mode
            limit: limit
        @_quantifyHTTP("get", "displaymetrics", data, callback)

    # Good code snippets here: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Using_XMLHttpRequest
    # HTTP Method abstracting the need to insert pID and key
    _quantifyHTTP: (method, entity, data, callback) -> 
        qntData =
            pID: @_project
            key: @_key
        url = @_base_url + "/" + entity + "?" + getQueryString(data) + "&" + getQueryString(qntData)
        xhr = new XMLHttpRequest()
        xhr.overrideMimeType("application/json"); 
        xhr.withCredentials = true;
        xhr.onload = (resp) ->
            callback(JSON.parse(resp.target.responseText))
            # console.log(xhr.getAllResponseHeaders().toLowerCase());
        xhr.open(method, url, true)
        xhr.send()
        

window.qnt = quantifyObject
console.log("Ran")