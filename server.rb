require 'sinatra'
require 'pry'
require 'csv'

set :public_folder, File.join(File.dirname(__FILE__), "public")

get "/" do
  redirect "/articles"
end

get "/articles" do
  @articles = CSV.read('articles.csv')
  erb :articles
end

get "/articles/new" do
  @temp_inputs = [["","",""]]
  erb :new_post
end

post "/articles/new" do
  title = params['title']
  url = params['url']
  description = params['description']
  @error = "Please enter a description of at least 20 characters." if description.length < 20
  @error = "Please enter a valid url." if !(url =~ /http:\/\/.*\.com/)
  @error = "Please enter a title." if title.empty?
  CSV.open("temp_inputs.csv", "wb") do |csv|
    csv << [title, url, description]
  end
  @temp_inputs = CSV.read('temp_inputs.csv')

  if @error
    erb :new_post
  else
    CSV.open("articles.csv", "ab") do |csv|
      csv << [title, url, description]
    end
    redirect '/articles'
  end
end
