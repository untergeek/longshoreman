# Longshoreman
Abstracting the Docker API for easier use with RSpec

See https://github.com/swipely/docker-api and https://rubygems.org/gems/docker-api
for more information about the Docker API gem.

## What is Longshoreman?

An instance of Longshoreman contains both an image object and a container
object which are completely independent of each other.  The image object is
primarily useful for building an image from a Dockerfile, and then creating a
container from that image.

## Usage

### Environment Variables

If you set the DOCKER_URL environment variable before launching your tests (or
script or application) the Docker API will automatically pick up the necessary
information.

### Methods

Create an instance with an empty container and image (the default):

>```
l = Longshoreman.new
```

Create a container from a known image in `repository:tag` format and start it in
one step:

>```
l = Longshoreman.new('ubuntu:latest', 'my_container_name')
```

Clean up the container and/or image associated with your Longshoreman instance:

>```
l.cleanup
```

Interact with the container:

>```
l.container.METHOD
```

Container methods include _all, cleanup, create, get, id, remove, rport, start
and stop._

_rport_ is used to return the randomized port mapped by Docker:

>```
# def rport(exposed_port, protocol='tcp')
> l.container.rport(10051)
 => 32791
```

Interact with the image:

>```
l.image.METHOD
```

Image methods include _build, remove, get, exist?, and id._

You also have full access to the Docker API gem's functionality for both the
image and container instances by way of `.raw`:

>```
l.container.raw.json
{...json output here...}
```

>```
l.image.raw.json
{...json output here...}
```
