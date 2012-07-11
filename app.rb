

helpers do

  # output renderer
  def render(format, content)

    formats = {:json => :json, :jsonp => :js }

    if !formats.has_key?(format)
      halt 400
    end

    content_type formats[format]

    case format
    when :json
      JSON.unparse(content)
    when :jsonp
      callback = params[:callback] || 'alert'
      "<script type=\"text/javascript\">#{callback}(#{JSON.unparse(content)})</script>"
    end
  end

end


get '/members.?:format?' do

  format = params[:format] || :json
  format = format.to_sym

  # fetch members
  db      = Mongo::Connection.new.db('ville')
  members = db.collection('member').find.to_a

  render(format, members)
end


get %r{/member/([a-zA-Z0-9]+)(\.(.+))?} do

  slug   = params[:captures].first

  format = params[:captures][2] || :json
  format = format.to_sym

  # fetch members
  db     = Mongo::Connection.new.db('ville')
  member = db.collection('member').find_one({:name => slug})

  halt 404 if member.empty?

  render(format, member)
end
