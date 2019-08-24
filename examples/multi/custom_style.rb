require_relative '../../lib/tty-spinner'
require_relative '../../lib/cli.rb'

def spinnerFunction

opts = {
  style: {
    top: "|->  ",
    middle: "|--> ",
    bottom: "|->  ",
  },
  format: :bouncing_ball
}
spinners = TTY::Spinner::Multi.new("[:spinner] Saving New User!", opts)

sp1 = spinners.register "[:spinner] Initializing your name"
sp2 = spinners.register "[:spinner] Inputting to the database"
# sp3 = spinners.register "[:spinner] three"

sp1.auto_spin
sp2.auto_spin
# sp3.auto_spin

sleep(0.25)
sp1.success
sleep(0.50)
sp2.success

# sleep 1
# sp3.success


end