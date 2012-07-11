
get '/members' do

  db = Mongo::Connection.new.db('ville')

  members    = db.collection('member').find.to_a

  content_type :json
  JSON.unparse(members)

end


get '/works' do
end
