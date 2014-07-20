# Use phusion/baseimage as base image.
FROM phusion/passenger-ruby21:0.9.12
MAINTAINER  Paul Coleman "pcoleman@coleman.co.uk"

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx info
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf

# Prepare folders
RUN mkdir /home/app/webapp

# Run Bundle in a cache efficient way. By adding Gemfile & Gemfile.lock to /tmp the bundle is cached.
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# Add the rails app
ADD . /home/app/webapp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

