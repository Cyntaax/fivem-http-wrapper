
Server = {
    Routes = {},
    Middlewares = {}
}

InvokeHttpRequest = nil

if SetHttpHandler == nil then
    SetHttpHandler = function(cb)
        InvokeHttpRequest = function(requestData, responseData)
            responseData.send = function(data)
                print("Sending", data)
            end
            responseData.writeHead = function(key, value)
                print("Writing to header", "status: " .. key, "headers", json.encode(value))
            end
            cb(requestData, responseData)
        end
    end
end

function Server.listen()
    SetHttpHandler(function(req, res)
        print(req.method .. " => " .. req.path)
        ---@type string
        local path = req.path
        local method = req.method
        for k,v in pairs(Server.Routes) do
            for b,z in pairs(v.Paths) do
                if string.match(path, "^" .. z.path .. "$") then
                    if z.method == method then
                        local response = Response.new(res)
                        local request = Request.new(req)
                        if z.pathData then
                            local start = 1
                            for i,j in path:gmatch(z.path) do
                                if z.pathData.params[start] == nil then break end
                                z.pathData.params[start].value = i
                                start = start + 1
                            end
                            for i,j in pairs(z.pathData.params) do
                                request:SetParam(j.name, j.value)
                            end
                        end
                        if z.method == "POST" then
                            req.setDataHandler(function(data)
                                request._Body = json.encode(data) or ""
                                local status, ret = z.handler(request, response)
                                if status ~= nil then
                                    if type(status) == "number" then
                                        if type(ret) ~= "table" then
                                            response:Send(ret)
                                        else
                                            response:Send(json.encode(ret))
                                        end
                                    end
                                end
                            end)
                        else
                            local status, ret = z.handler(request, response)
                            if status ~= nil then
                                if type(status) == "number" then
                                    if type(ret) ~= "table" then
                                        response:Send(ret)
                                    else
                                        response:SetHeader("Content-Type", "application/json")
                                        response:Send(json.encode(ret))
                                    end
                                end
                            end
                        end
                        return
                    end
                end
            end
        end
        local response = Response.new(res)
        local request = Request.new(req)
        response:Status(404)
        response:Send("Not Found: " .. request:Method() .. " " .. request:Path())
    end)
end


function Server.use(path, handler)
    if type(path) == "string" then
        if type(handler) == "function" then

        elseif type(handler) == "table" then
            local mt = getmetatable(handler)
            if mt == nil then print("^1Error^0: " + "failed to load route " + path + "expected route class") return end
            if mt.__call() ~= "Router" then print("^1Error^0: " + "failed to load route " + path + "expected route class") return end
            for k,v in pairs(handler.Paths) do
                print("Mounting: ", path .. v.path)
                v.path = path .. v.path
            end
            table.insert(Server.Routes, handler)
        end
    end
end
