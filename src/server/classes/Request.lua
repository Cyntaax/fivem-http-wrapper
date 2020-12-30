---@class Request
Request = setmetatable({}, Request)

Request.__call = function()
    return "Request"
end

Request.__index = Request

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

function Request:Param(name)
    return self._Params[name]
end

function Request:Params()
    return self._Params
end

function Request:SetParam(name, val)
    self._Params[name] = val
end

function Request:Body()
    return self._Body
end

function Request:Path()
    return self._Raw.path
end

function Request:Method()
    return self._Raw.method
end
