---@class Request
Request = setmetatable({}, Request)

Request.__call = function()
    return "Request"
end

Request.__index = Request

--- Creates a new Request class instance
---@param request table Expects a request object from the `SetHttpHandler` callback
function Request.new(request)

    local _Request = {
        _Raw = request,
        _Params = {}
    }

    request.body = request.body or ""

    if json.decode(request.body) then
        _Request._Body = json.decode(request.body)
    else
        _Request._Body = request.body
    end

    return setmetatable(_Request, Request)
end

--- Get the value for a named parameter. i.e. `/users/:id` to fetch "id" use `Request:Param("id")`
---@param name string Name of the parameter to get
---@return string
function Request:Param(name)
    return self._Params[name]
end

--- Returns all parameters as a table
---@return table
function Request:Params()
    return self._Params
end

--- Sets the value of a parameter. (internal)
---@private
---@param name string The name of the parameter to set
---@param val string The value of this parameter
function Request:SetParam(name, val)
    self._Params[name] = val
end

--- Returns the body of this request
---@return string|table
function Request:Body()
    return self._Body
end

--- Returns the path of this request
---@return string
function Request:Path()
    return self._Raw.path
end

--- Returns the method of this request
---@return string
function Request:Method()
    return self._Raw.method
end
