class Longshoreman::Container

  def initialize(image = nil, name = nil, extra_args = {})
    if image && name
      create(image, name, extra_args)
      start
    else
      @raw = nil
    end
  end

  def all(opts = {})
    @raw.all(opts)
  end

  # Wrapper to clean up container in a single call
  # name can be a name or id
  def cleanup
    if @raw
      @raw.stop
      @raw.delete(:force => true)
    end
  end

  # Create a docker container from an image (or repository:tag string), name,
  # and optional extra args.
  def create(image, name, extra_args={})
    # If this ends up getting integrated, we'll use @logger.error here
    case image.class.to_s
    when "Docker::Image"
      i = image.id
    when "String"
      if image.include? ':' # repository:tag format
        i = image
      else
        puts "Image string must be in 'repository:tag' format."
        return
      end
    else
      puts "image must be Docker::Image or in 'repository:tag' format"
      return
    end

    # Don't change the non-capitalized 'name' here.  The Docker API gem extracts
    # this key and uses it to name the container on create.
    main_args = {
      'name' => name,
      'Hostname' => name,
      'Image' => i,
      'PublishAllPorts' => true,
      'CapAdd' => ['NET_ADMIN'],
    }
    @raw = Docker::Container.create(main_args.merge(extra_args))
  end

  # This get method is not a "pass thru"
  def get(id, opts = {})
    @raw = Docker::Container.get(id, opts)
  end
  
  def id
    @raw.id
  end

  def remove
    @raw.remove(:force => true)
  end
  alias_method :delete, :remove

  # Return the randomized port number associated with the exposed port.
  def rport(exposed_port, protocol="tcp")
    # Get all mapped ports
    ports = @raw.json["NetworkSettings"]["Ports"]
    # We're going to expect 1:1 mapping here
    ports["#{exposed_port.to_s}/#{protocol}"][0]["HostPort"].to_i
  end

  def start
    @raw.start
  end

  def stop
    @raw.stop
  end

  def network_delay(ms)
    @raw.exec(['tc', 'qdisc', 'add', 'dev', 'eth0', 'root', 'netem', 'delay', '#{ms}ms'])
  end

  def remove_network_delay
    @raw.exec(['tc', 'qdisc', 'del', 'dev', 'eth0', 'root', 'netem'])
  end

  attr_accessor :raw
end
