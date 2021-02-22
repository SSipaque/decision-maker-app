require 'sinatra'
require 'sqlite3'
require 'data_mapper'
#require 'rails'

#Remember that you have to downgrade the version of Sinatra, or you get an error about the version of JSON.

#so. > gem uninstall sinatra

#> gem install sinatra -v 1.4.6

#also need to install dm-sqlite-adapter gem apparently
 
set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

 
 #sets up and creates a new database 
 DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")
 
class Option
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true
  
end
 
DataMapper.finalize.auto_upgrade!
       
        
get '/' do
   #@options = Option.all :order => :id.desc
   #@title = 'All Options'
    erb :home
end        

post '/insert' do 
#retrieves the input from the form and adds it into the database
  option = params['option']
 
  @O = Option.new
  @O.name = option
  @O.save
  
  @options2 = Option.all :order => :id.desc 
  
  erb :options 
  
end

post '/home' do

erb :home
end

post '/go' do 
#pulls a random option from the database
@random_option = Option.all.map(&:name).sample
  erb :decision
  
end 
