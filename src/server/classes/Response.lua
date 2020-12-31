---@class Response
Response = setmetatable({}, Response)

Response.__call = function()
    return "Response"
end

Response.__index = Response

--- Creates a new instance of the Response class
---@param response table The response object from the `SetHttpHandler` callback
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

--- Sets a header for the response
---@param key string Name of the header to set
---@param value string Value for this header
function Response:SetHeader(key, value)
    self.Headers[key] = value
end

--- Gets or sets the status of the response
---@param status number The HTTP status code to set
---@return nil|number
function Response:Status(status)
    if status == nil then return self._Status end
    self._Status = tonumber(status) or 200
    return self
end

--- Sends the response. If the data type is a table, it will be automatically converted to a JSON string
---@param data string|table The data to send
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

