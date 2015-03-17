local json = require "cjson"
local str = require "resty.string"

expires_after = 3600

--headers = ngx.req.get_headers();
user = ngx.var.arg_user
pw = ngx.var.arg_pw

-- got user
if user ~= nil and pw ~= nil then

-- erich: add back in to ensure we check the user and don't accept everything
-- accept any user for now
--   ngx.log(1, ngx.var.users)
--   if ngx.var.users[user] ~= pass then
--      return
--   end
   ngx.log(ngx.STDERR, "Got user: " .. user)
   
--   if ngx.var.users[user] ~= pass then
   if user == "erich" and pw == "yo" then
      ngx.log(ngx.STDERR, 'Authenticated' .. user)
      local expiration = ngx.time() + expires_after
      local token = expiration .. ":" .. str.to_hex(ngx.hmac_sha1(ngx.var.lua_auth_secret, expiration))

      local jsonStr = json.encode{ token = token }
      ngx.header.content_type = 'application/json'
      ngx.say(jsonStr)
      ngx.log(ngx.STDERR, "token: " .. token)
      return
   end

end 

ngx.header.content_type = 'text/plain'
ngx.status = ngx.HTTP_UNAUTHORIZED
ngx.say('401 Access Denied')

