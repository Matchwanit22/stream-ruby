module Stream
  class URLGenerator
    attr_reader :options
    attr_reader :base_path
    attr_reader :url
  end

  class APIURLGenerator < URLGenerator
    def initialize(options)
      @options = options
      location = make_location(options[:location])
      api_version = options[:api_version] ? options[:api_version] : 'v1.0'
      @base_path = "/api/#{api_version}"
      if ENV['STREAM_URL']
        uri = URI::parse(ENV['STREAM_URL'])
        scheme = uri.scheme
        host = uri.host
        port = uri.port
      else
        scheme = 'https'
        host = options[:api_hostname]
        port = 443
      end
      unless ENV['STREAM_URL'] =~ /localhost/
        host_parts = host.split('.')
        host = host_parts.slice(1..-1).join('.') if host_parts.length == 3
        host = "#{location}.#{host}" if location
      end
      @url = "#{scheme}://#{host}:#{port}/#{@base_path}"
    end

    private

    def make_location(loc)
      case loc
      when 'us-east'
        'us-east-api'
      when 'eu-west'
        'eu-west-api'
      when 'singapore'
        'singapore-api'
      else
        loc
      end
    end
  end
end