require 'docker'

class Longshoreman
  
  def initialize(image = nil, name = nil, extra_args = {})
    Docker.options = { :write_timeout => 300, :read_timeout => 300 }
    Docker.validate_version!

    @ip = get_host_ip
    @container = Longshoreman::Container.new(image, name, extra_args)
    @image = Longshoreman::Image.new
  end

  # Figure out which IP address the Docker host is at
  def get_host_ip
    # Let the crazy one-liner definition begin:
    # Docker.url.split(':')[1][2..-1]
    # Docker.url = tcp://192.168.123.205:2375
    #   split(':') = ["tcp", "//192.168.123.205", "2375"]
    #   [1] = "//192.168.123.205"
    #   [2..-1] = "192.168.123.205"
    # This last bit prunes the leading //
    url = Docker.url
    case url.split(':')[0]
    when 'unix'
      "127.0.0.1"
    when 'tcp'
      url.split(':')[1][2..-1]
    end
  end

  def cleanup
    @container.cleanup
    @image.cleanup
  end

  def self.pull_image(image, tag)
    `docker pull #{image}:#{tag}`
  end

  attr_reader :ip
  attr_accessor :container
  attr_accessor :image

end

require 'longshoreman/image'
require 'longshoreman/container'
