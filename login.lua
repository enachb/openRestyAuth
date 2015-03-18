local json = require "cjson"
local str = require "resty.string"

users = { sum = "TingWong", wi = "ToLo", ho = "LeeFuk", oink = "oink" }

expires_after = 3600

--headers = ngx.req.get_headers();
user = ngx.var.arg_user
pw = ngx.var.arg_pw

-- got user and password in URL
if user ~= nil and pw ~= nil then
   ngx.log(ngx.DEBUG, "Got user: " .. user)
  
   if users[user] ~= pass then
--   if user == "erich" and pw == "yo" then
      ngx.log(ngx.DEBUG, 'Authenticated' .. user)
      local expiration = ngx.time() + expires_after
      local token = expiration .. ":" .. str.to_hex(ngx.hmac_sha1(ngx.var.lua_auth_secret, expiration))

      local jsonStr = json.encode{ token = token }
      ngx.header.content_type = 'application/json'
      ngx.say(jsonStr)
      ngx.log(ngx.DEBUG, "token: " .. token)
      return
   end

end 

ngx.header.content_type = 'text/plain'
ngx.status = ngx.HTTP_UNAUTHORIZED
ngx.say('401 Access Denied')

