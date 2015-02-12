class ApplicationController < Sinatra::Base

  set :root, Proc.new { File.expand_path('../..', __FILE__) }
  set :views, Proc.new { File.join(root, 'views') }
  set :public_folder, Proc.new { File.join(root, 'public') }
end
