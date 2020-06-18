--- @class HTTP
HTTP = {}

HTTP.App = {}

HTTP.Bootstrap = function(handler)
    handler()
end

HTTP.Router = {}

HTTP.Headers = {}

--- @class Headers
HTTP._Headers = {}

--- @type number The response code for this request
HTTP._Status = 200

HTTP.Router.Handlers = {}

HTTP.Router.Handlers.POST = {}

HTTP.Router.Handlers.GET = {}

--- @param header string The name of which header to set
--- @param value string The value for this header
function HTTP.Headers:Set(header, value)
    HTTP._Headers[header] = value
end

--- @param status number The http status of this request
function HTTP.Headers:Status(status)
    HTTP._Status = tonumber(status) or 200
end

--- @return Headers
--- Returns headers
function HTTP.Headers:All()
    return HTTP._Headers
end

--- @param path string The path for this endpoint e.g. /test
--- @param handler function Requires parameters (request, response)
function HTTP.Router:POST(path, handler)
    HTTP.Router.Handlers.POST[path] = handler
end

--- @param path string The path for this endpoint e.g. /test
--- @param handler function Requires parameters (request, response)
function HTTP.Router:GET(path, handler)
    HTTP.Router.Handlers.GET[path] = handler
end

local resource = GetCurrentResourceName()

function HTTP.App:Listen()
    SetHttpHandler(function(req, res)
        HTTP.Bootstrap(function()
            for k,v in pairs(HTTP.Router.Handlers) do
                if k == req.method then
                    if v[req.path] ~= nil then
                        if req.method == 'POST' then
                            req.setDataHandler(function(data)
                                req.body = json.decode(data)
                                v[req.path](req, res)
                            end)
                        else
                            v[req.path](req, res)
                        end
                    else
                        res.send('not found')
                    end
                end
            end
        end)
    end)
    print("^3(http): ^2Created app for " .. resource)
end


HTTP.App:Listen()