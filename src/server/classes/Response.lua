---@class Response
Response = setmetatable({}, Response)

Response.__call = function()
    return "Response"
end

Response.__index = Response

function Response.new(response)
    local _Response = {
        _Raw = response,
        Headers = {
            ["X-POWERED-BY"] = "Cyntaax-FiveM-Express"
        },
        _Status = 200
    }

    return setmetatable(_Response, Response)
end

function Response:SetHeader(key, value)
    self.Headers[key] = value
end

function Response:Status(status)
    if status == nil then return self._Status end
    self._Status = tonumber(status) or 200
end

function Response:Send(data)
    if type(data) ~= "string" then
        if type(data) == "number" then
            data = tostring(data)
        elseif type(data) == "boolean" then
            data = tostring(data)
        elseif type(data) == "table" then
            data = json.encode(data) or ""
        end
    end

    self._Raw.writeHead(self:Status(), self.Headers)

    self._Raw.send(data)
end

