class Longshoreman::Image

  def initialize
    @raw = nil
  end

  # Build an image from a Dockerfile
  def build(dockerfile_path)
    dockerfile = IO.read(dockerfile_path)
    @raw = Docker::Image.build(dockerfile)
    @raw # Return the image without having to add .raw
  end

  # This is useful if you're building from Dockerfiles each run
  def remove
    if @raw
      @raw.remove(:force => true) if @raw.exist?(@raw.id)
    end
  end
  alias_method :cleanup, :remove

  def exist?(id, opts = {})
    @raw.exist?(id, opts)
  end

  # Return the image object identified by repository:tag
  def get(repository, tag)
    images = Docker::Image.all.select { |i|
      i.info["RepoTags"].include? "#{repository}:#{tag}"
    }
    # I don't think it's possible to have multiple images from the same
    # repository with the same tag, so this shouldn't be an issue.
    @raw = images[0]
  end

  # Return the id
  def id
    @raw.id
  end

  attr_accessor :raw

end
