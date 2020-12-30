if Citizen == nil then
    require("util.pattern")
    json = require("util.json")
    require("classes.Request")
    require("classes.Response")
    require("classes.Router")
    require("classes.HTTP")

end
local r = Router.new()

r:Post("/", function(req, res)
    print("Handling stuff")
    return 200, {data = "sent"}
end)

r:Post("/:userid", function(req, res)
    print("user id post", req:Param("userid"))
    print("Body", req:Body())
    res:Send("user id was " .. req:Param("userid"))
end)

r:Get("/test/something", function(req, res)
    print("/user/test endpoint")
end)

Server.use("/users", r)

Server.listen()

local request = {
    path = "/users/stephen",
    method = "POST",
    body = 'regular text',
    setDataHandler = function(cb)
        cb({}, {})
    end
}

local response = {

}

if Citizen == nil then
    InvokeHttpRequest(request, response)
    InvokeHttpRequest({path = "/users/test/something", method="GET"}, {})
end


