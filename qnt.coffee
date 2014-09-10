### Copyright (c) 2014 MIT Media Lab, https://qnt.io ###

# TODO Use encodeURIComponent?
getQueryString = (obj) ->
    s = []
    for k, v of obj
        s.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
    s.join("&")

quantifyObject = 
    _version: "0.0.1"
    _key: "key"
    _project: "earth_tapestry"
    # List of all entities it's valid to request
    _allowedEntities: [
        'displayMetrics'
    ]

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

    getMetrics: (limit, mode, callback) -> 
        data =
            limit: limit
            mode: mode
        @_quantifyHTTP("get", "displaymetrics", data, callback)

    # Good code snippets here: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Using_XMLHttpRequest
    _quantifyHTTP: (method, entity, data, callback) -> 
        # base = "https://www.qnt.io/api"
        base = "http://quantify.media.mit.edu:8888/api"
        qntData =
            pID: @_project
            key: @_key
        url = base + "/" + entity + "?" + getQueryString(data) + "&" + getQueryString(qntData)
        console.log("Full Request URL:", url)
        xhr = new XMLHttpRequest()
        xhr.overrideMimeType("application/json"); 
        xhr.onload = (resp) ->
            callback(JSON.parse(resp.target.responseText))
        xhr.open(method, url, true)
        xhr.send()

window.qnt = quantifyObject
console.log("Ran")