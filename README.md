#FiveM Lua HTTP Wrapper

### Create endpoints in your resources with ease!

### Features
    - Router
    - Automatic JSON data handling
    - Pattern based routes

### Examples

Simple example

```lua
local r = Router.new()
r:Get("/", function(req, res)
    res:Send("A Simple response!")
end)

Server.use("", r)
Server.listen()
```

You can also use return values, an alternative to the above:
```lua
local r = Router.new()
r:Get("/", function(req, res)
    return 200, "A simple response!"
end)

Server.use("", r)
Server.listen()
```

Pattern Based Routes
```lua
local r = Router.new()
r:Get("/:steamid", function(req, res)
    local steamid = req:Param("steamid")
    res.send("The steam id was " .. steamid)
end)

Server.use("/users", r)
Server.listen()
```

```
curl -X GET http://localhost:30120/resource-name/users/steam:9494000210
The steam id was steam:9494000210
```

