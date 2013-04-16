$LOAD_PATH << '.'

require 'bundler/setup'
require 'docify'
require 'sinatra'
require 'sinatra/assetpack'
require 'app/lib/highlight'

VERSION = '0.3.5'

configure do
  set :views, 'app/views'
end

configure :production do
  set :show_exceptions, false
  set :dump_errors,     false
  set :raise_errors,    false
end

assets do
  serve '/js',  :from => 'app/js'
  serve '/css', :from => 'app/css'

  css :app, [
    '/css/master.css',
    '/css/github.css',
  ]

  js :app, [
    'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min.js',
    'http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js',
    '/js/tabby.js',
    '/js/highlight.pack.js',
    '/js/application.js'
  ]
end

helpers do
  def app_version
    VERSION
  end
end

get '/' do
  erb :editor
end

get '/sample' do
  @content = File.read(File.join(settings.root, 'README.md'))
  erb :editor
end

post '/render' do
  content = params[:content].to_s
  markup  = params[:markup] || 'markdown'

  if content.empty?
    return ""
  end

  if !Docify.valid_format?(params[:markup])
    halt 400, "Invalid markup"
  end

  Highlight.render(content, markup)
end