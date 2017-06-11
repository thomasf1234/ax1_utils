require 'io/console'

module Ax1Utils
  class Prompt
    def initialize(is=STDIN, os=STDOUT)
      @is = is
      @os = os
    end

    def prompt_username(prompt="Username: ")
      username = nil
      has_username = false

      until has_username
        @os.print prompt
        username = @is.gets.chomp

        if username.length < 2
          @os.puts("Usernames must be at least 2 characters long. Retrying")
          next
        else
          has_username = true
        end
      end

      username
    end

    def prompt_password(prompt="Password: ")
      password = nil
      has_password = false

      until has_password
        password = @is.getpass(prompt)

        if password.length < 6
          @os.puts("Passwords must be at least 6 characters long. Retrying")
          next
        end

        confirm_password = @is.getpass("Confirm Password: ")

        if password == confirm_password
          has_password = true
        else
          @os.puts("Incorrect password entered. Restarting")
          next
        end
      end

      password
    end
  end
end