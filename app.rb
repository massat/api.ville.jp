
@@formats = {:json => :json, :jsonp => :js }


get '/members.?:format?' do

  # determines format
  format  = params[:format] || :json
  format  = format.to_sym

  if !@@formats.has_key?(format)
    halt
  end

  content_type @@formats[format]


  # fetch members
  db = Mongo::Connection.new.db('ville')
  @members = db.collection('member').find.to_a


  case format
  when :json
    JSON.unparse(@members)
  when :jsonp
    callback = params[:callback] || 'alert'
    "<script type=\"text/javascript\">#{callback}(#{JSON.unparse(@members)})</script>"
  end

end
