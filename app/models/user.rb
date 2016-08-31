class User < ActiveResource::Base
  self.headers["HTTP_AUTHORIZATION"] = 'Token token="2406cc23331a3d6a19c26c4908e8a00d"'
  self.site = "http://localhost:3001"
end
