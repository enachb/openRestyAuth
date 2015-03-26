    local str = require "resty.string"

    ngx.log(ngx.DEBUG,"XXXXXXXXXX entering checkToken.lua ")

    -- Some variable declarations.
    local hmac = ""
    local timestamp = ""

    local header = ngx.req.get_headers()

    function checkToken(token)
        -- Check that the token exists.
        ngx.log(ngx.DEBUG,"checkToken ")
        if token ~= nil and token:find(":") ~= nil then
            -- If there's a token, split off the HMAC signature
            -- and timestamp.
            local divider = token:find(":")
            hmac = token:sub(divider+1)
            timestamp = token:sub(0, divider-1)
            -- Verify that the signature is valid.
            if str.to_hex(ngx.hmac_sha1(ngx.var.lua_auth_secret, timestamp)) == hmac and tonumber(timestamp) >= ngx.time() then
                ngx.log(ngx.DEBUG,"Token verified ")
                return true
            end
        end
        ngx.log(ngx.DEBUG,"Token rejected")
        return false
    end

    if header ~= nil and header["Authorization"] ~= nil then

        local token = header["Authorization"]
        ngx.log(ngx.DEBUG,"XXXXXXXXXX Found  token: " .. token)
        -- if you want to catch an exception it has to be a function wrapped in pcall
        local noException, validToken= pcall(checkToken, token)
 
        if noException and validToken then 
            -- verified token
            ngx.log(ngx.DEBUG,"Supplied token ok." .. token)
            return
        else
            -- no go
            ngx.status = ngx.HTTP_UNAUTHORIZED
            ngx.say('401 Access Denied')
            ngx.exit(ngx.HTTP_UNAUTHORIZED)        
        end
    else 
        ngx.log(ngx.DEBUG,"********** token: missing")
        -- no go
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say('401 Access Denied')
        ngx.exit(ngx.HTTP_UNAUTHORIZED)        
    end
