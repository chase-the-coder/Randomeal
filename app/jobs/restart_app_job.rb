require 'platform-api'

class RestartAppJob < ApplicationJob
  queue_as :restarts
  class Dyno
    attr_accessor :type
    attr_accessor :name
    attr_accessor :state

    def self.connection
      if ENV['RESTART_API_KEY']
        @@connection ||= PlatformAPI.connect_oauth(ENV['RESTART_API_KEY'])
      end
    end

    def self.dynos
      connection.dyno.list(ENV['APP_NAME']).map do |dyno_info|
        Dyno.new(dyno_info)
      end
    end

    def self.running_web_dynos
      dynos.select { |dyno| dyno.web? && dyno.up? }
    end

    def web?
      type == 'web'
    end

    def up?
      state == 'up'
    end

    def connection
      self.class.connection
    end

    def restart!
      connection.dyno.restart(ENV['APP_NAME'], name)
    end

    def initialize(info)
      self.type = info['type']
      self.name = info['name']
      self.state = info['state']
    end
  end

  def perform(*args)
    if Dyno.connection
      Dyno.running_web_dynos.each do |dyno|
        dyno.restart!
      end
    end
  end
end

