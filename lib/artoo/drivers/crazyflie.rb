require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The crazyflie driver behaviors
    class Crazyflie < Driver
      COMMANDS = [:start, :stop, :hover, :land, :take_off, :emergency, 
                  :up, :down, :left, :right, :forward, :backward, 
                  :turn_left, :turn_right].freeze


      attr_reader :roll, :pitch, :yaw, :thrust, :xmode

      def initialize(params={})
        @roll = 0
        @pitch = 0
        @yaw = 0
        @thrust = 0
        @xmode = false # TODO what is this?
        super
      end

      # Start driver and any required connections
      def start_driver
        begin
          every(interval) do
            send_command
          end

          super
        rescue Exception => e
          Logger.error "Error starting Crazyflie driver!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def start
        @roll = 0
        @pitch = 0
        @yaw = 0
        @thrust = 10001
      end

      def stop
        set_thrust_off
      end

      def hover
        # TODO: call firmware that can do this?
      end

      def land
      end

      def take_off
      end

      def up(deg)
        @pitch = deg
        set_thrust_on
      end

      def down(deg)
        @pitch = -deg
        set_thrust_on
      end

      def left(deg)
        @roll = -1 * deg
        set_thrust_on
      end

      def right(deg)
        @roll = deg
        set_thrust_on
      end

      def forward(deg)
        @roll = 0
        set_thrust_on
      end

      def backward(deg)
        set_thrust_on
      end

      def turn_left
      end

      def turn_right
      end

    private

      def set_thrust_on
        @thrust = 20000
      end

      def set_thrust_off
        @thrust = 0
      end

      def send_command
        connection.commander.send_setpoint(roll, pitch, yaw, thrust, xmode)
      end
    end
  end
end
