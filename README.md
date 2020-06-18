FiveM Lua HTTP Wrapper
---------------------

This is just something I created for personal use, but publishing since it seems to be so nifty.

This wrapper makes it very easy to create endpoints for you FiveM server. This only supports `GET` and `POST` requests for the time being.

For post requests, it will assume the body to be `json` and decode it to be available in `res.body`

There are some thing that could be made easier and will be in time!



## Usage
require `HTTP.lua` in the `fxmanifest.lua`, i.e.

```lua
server_scripts {
    '@http-wrapperp/HTTP.lua'
}
```


## Example

```shell
curl -X POST http://localhost:30120/test-resource/
```

Should return

```
Hey, you sent a post request!
```
```lua
--- in resource [test-resource]
HTTP.Router:POST("/", function(req, res)
    res.send("Hey, you sent a post request!")
end)
```

```shell
curl -X POST http://localhost:30120/test-resource/myendpoint
```

Should return

```json
{
    "message": "Hello there!"
}
```

```lua
--- in resource [test-resource]
HTTP.Router:POST('/myendpoint', function(req, res)
    local data = json.encode({
        message = "Hello there!"
    })
    HTTP.Headers:Set("Content-Type", "application/json")
    HTTP.Headers:Status(200)
    res.writeHead(HTTP._Status, HTTP.Headers:All())
    res.send(data)
end)