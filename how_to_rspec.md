# Getting Started

## Installing Docker and Boot2Docker on Mac OS X

Docker does not run natively on OSX, so you must set up a
[Boot2Docker] virtual environment

To install, you can use brew. First you must install cask

```bash
brew tap caskroom/cask
brew install brew-cask
```

now we can install virtualbox and boot2docker

```bash
brew cask install virtualbox
brew cask install boot2docker
```

## Setting Environment Variables for Docker

```bash
eval "$(boot2docker shellinit)"
```

## Integrating With Your Rspec

In your gemspec you will need to add `longshoreman` as a 
development dependency.

```ruby
Gem::Specification.new do |s|
  ...
  s.add_development_dependency 'longshoreman'
  ...
end
```
### RSpec Configuration

You may want to only run your docker instance during integration testing. Here is 
a sample rspec configuration that will ensure your service within the specific container 
is running before your integration test.

```ruby
# configure your rspec suite to launch container before running
# integration tests
Rspec.configure do |config|
  # this :all hook gets run before every describe block that is tagged with :integration => true.
  config.before(:all, :integration => true) do
    begin
      # create new Longshoreman with no container set
      ls = Longshoreman.new
      # search local docker daemon to see if container is 
      # already running. Since configure.before(:all) runs before 
      # each "it" block, a container may already be running for this 
      # integration suite
      ls.container.get(CONTAINER_NAME)
    rescue Docker::Error::NotFoundError # returned if container named CONTAINER_NAME is not running
      # attempt to run image under a new container named CONTAINER_NAME
      Longshoreman.new("#{CONTAINER_IMAGE}:#{CONTAINER_TAG}", CONTAINER_NAME)
    end
  end

  # we want to do a final cleanup after all :integration runs,
  # but we don't want to clean up before the last block.
  # This is a final blind check to see if the ES docker container is running and
  # needs to be cleaned up. If no container can be found and/or docker is not
  # running on the system, we do nothing.
  config.after(:suite) do
    begin
      # only cleanup docker container if system has docker and the container is running
      ls = Longshoreman::new
      ls.container.get(CONTAINER_NAME)
      ls.cleanup
    rescue Docker::Error::NotFoundError, Excon::Errors::SocketError
      # do nothing, if error occurs this means that container is most likely not 
      # running, so no further cleanup is necessary. Operational checks on system's 
      # Docker daemon may be required.
    end
  end
end
```

## Retrieving Container Host and IP

It is typical to be running a service with a network interface within the 
container. Longshoreman provides two mechanisms for retrieving the host and IP 
information.

assuming you have a Longshoreman container called `container` running a web 
service and you wish to retrieve the container's port mapping for port `80`.
You can call `rport` on it to retrieve the mapped port for the exposed service 
listening on port `80` within the container.

```ruby 
container.rport(80)
```

You may not be running your Docker instance on your local system, and 
may be using docker-machine or boot2docker to run Docker within a virtual machine.
To retrieve your local Docker daemon's host, you can run the following

```ruby
Longshoreman.new.get_host_ip
```
