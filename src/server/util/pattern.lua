---@private
--- Converts a string pattern "`/users/:id`" to an object for the Request class to use
function PatternToRoute(input)
    if input == "/" then input = "" end
    local routeData = {
        route = input,
        params = {}
    }
    local matcher = input
    for k,v in input:gmatch "/(:%w+)" do
        local rawname = k:gsub(":", "")
        table.insert(routeData.params, {
            name = rawname
        })
        matcher, _ = matcher:gsub(k, "(%%w+)", 1)
    end
    routeData.route = matcher
    return routeData
end
