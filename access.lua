
ngx.log(ngx.STDERR,"XXXXXXXXXX entering access.lua ")


-- Some variable declarations.
local cookie = ngx.var.cookie_Auth
local hmac = ""
local timestamp = ""

if ngx.var.uri == "/auth/" then
    return
end

-- Check that there is a token
local token = ngx.var.arg_token


function checkToken(token)
-- Check that the token exists.
ngx.log(ngx.STDERR,"checkToken ")
if token ~= nil and token:find(":") ~= nil then
    -- If there's a token, split off the HMAC signature
    -- and timestamp.
    local divider = token:find(":")
    hmac = ngx.decode_base64(token:sub(divider+1))
    timestamp = token:sub(0, divider-1)
    -- Verify that the signature is valid.
    if ngx.hmac_sha1(ngx.var.lua_auth_secret, timestamp) == hmac and tonumber(timestamp) >= ngx.time() then
        ngx.log(ngx.STDERR,"Token verified ")
        return true
    else
        ngx.log(ngx.STDERR,"Token rejected")
        return false
    end
end
end

if token ~= nil then
    ngx.log(ngx.STDERR,"XXXXXXXXXX Found  token: " .. ngx.var.arg_token)
    noException, validToken= pcall(checkToken(), token)

    if noException and validToken then 
        -- verified token
        ngx.log(ngx.STDERR,"Supplied token ok." .. ngx.var.arg_token)
        return
    else
        -- no go
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say('401 Access Denied')
        ngx.exit(ngx.HTTP_UNAUTHORIZED)        
    end
else 
    ngx.log(ngx.STDERR,"********** token: missing")
end

-- Check that the cookie exists.
if cookie ~= nil and cookie:find(":") ~= nil then
    ngx.log(ngx.STDERR,"XXXXXXXXXX Found  cookie " .. cookie)
    -- If there's a cookie, split off the HMAC signature
    -- and timestamp.
    local divider = cookie:find(":")
    hmac = ngx.decode_base64(cookie:sub(divider+1))
    timestamp = cookie:sub(0, divider-1)
    -- Verify that the signature is valid.
    if ngx.hmac_sha1(ngx.var.lua_auth_secret, timestamp) == hmac and tonumber(timestamp) >= ngx.time() then
     return
    end
end

-- Internally rewrite the URL so that we serve
-- /auth/ if there's no valid token.
ngx.exec("/auth/")
