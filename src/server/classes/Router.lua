---@class Router
Router = setmetatable({}, Router)

Router.__call = function()
    return "Router"
end

Router.__index = Router

function Router.new()
    local _Router = {
        Paths = {}
    }

    return setmetatable(_Router, Router)
end

---@param path string
---@param handler fun(req: Request, res: Response): void
function Router:Get(path, handler)
    local parsed = PatternToRoute(path)
    table.insert(self.Paths, {
        method = "GET",
        path = parsed.route,
        handler = handler,
        pathData = parsed
    })
end

---@param path string
---@param handler fun(req: Request, res: Response): void
function Router:Post(path, handler)
    local parsed = PatternToRoute(path)
    table.insert(self.Paths, {
        method = "POST",
        path = parsed.route,
        handler = handler,
        pathData = parsed
    })
end
