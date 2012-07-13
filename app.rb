require 'mongo'
require 'json'
require 'sinatra/base'

module Jp
  module Ville
    class Api < Sinatra::Base

      configure :development do
        set :dsn, { :host => '127.0.0.1', :port => 27017, :db => 'ville'}
      end

      # /members[.:format]
      get %r{/members(\.(.+))?} do

        format = params[:captures].nil? ? :json : params[:captures][1]
        format = format.to_sym

        # fetch members
        members = get_connection.collection('member').find.to_a

        render(format, members)

      end

      # /member/:slug[.:format]
      get %r{/member/([a-zA-Z0-9]+)(\.(.+))?} do

        slug   = params[:captures].first

        format = params[:captures][2] || :json
        format = format.to_sym

        # fetch member
        member = get_connection.collection('member').find_one({:slug => slug})

        halt 404 if member.empty?

        render(format, member)

      end

      helpers do

        # get db connection
        def get_connection
          dsn = settings.dsn
          Mongo::Connection.new(dsn[:host], dsn[:port]).db(dsn[:db])
        end

        # output renderer
        def render(format, content)

          formats = {:json => :json, :jsonp => :js }

          if !formats.has_key?(format)
            halt 400
          end

          content_type formats[format]

          case format
            when :json
              content.to_json
            when :jsonp
              callback = params[:callback] || 'alert'
              "<script type=\"text/javascript\">#{callback}(#{JSON.unparse(content)})</script>"
          end
        end

      end

    end
  end
end
