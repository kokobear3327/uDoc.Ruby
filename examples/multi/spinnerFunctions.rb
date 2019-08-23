require_relative '../../lib/tty-spinner'



def spinnerFunctionForMainScreen

  spinner = TTY::Spinner.new("[:spinner] Loading:", format: :arrow_pulse)

  spinner.auto_spin # Automatic animation with default interval
  
  sleep(2) # Perform task
  
  spinner.stop('Complete') # Stop animation
  # spinner.success

end



def spinnerFunction2

    spinner = TTY::Spinner.new("[:spinner] Loading..", format: :pulse_2)

    spinner.auto_spin # Automatic animation with default interval
    
    sleep(1) # Perform task
    
    spinner.stop('Complete') # Stop animation

end

def spinnerFunctionDotsForGoRogueBase

  opts = {
      style: {
        top: "|->  ",
        middle: "|->  ",
        bottom: "|->  ",
      },
      format: :dots_2
    }
    spinners = TTY::Spinner::Multi.new("[:spinner] Calling the database!", opts)

  sp1 = spinners.register "[:spinner] Populating models"
  # or sp1 = ::TTY::Spinner.new("[:spinner] one")
  # sp2 = spinners.register "[:spinner] Inputting to the database"
  sleep(0.6)
  sp1.auto_spin
  sleep(0.6)
  # sp2.auto_spin
  # sleep(1)
  

  sp1.success
  sleep(0.6)
  # sp2.success
  
end

def spinnerFunctionDotsForSearchingForDoctors

  opts = {
      style: {
        top: "|->  ",
        middle: "|--> ",
        bottom: "|->  ",
      },
      format: :dots_8
    }
    spinners = TTY::Spinner::Multi.new("[:spinner] Initializing database!", opts)

  sp1 = spinners.register "[:spinner] Populating doctors"
  # or sp1 = ::TTY::Spinner.new("[:spinner] one")
  # sp2 = spinners.register "[:spinner] Inputting to the database"
  sleep(0.6)
  sp1.auto_spin
  sleep(0.6)
  # sp2.auto_spin
  # sleep(1)
  

  sp1.success
  sleep(0.6)
  # sp2.success
  
end

def spinnerFunctionDotsForUpdatingProfile

  opts = {
      style: {
        top: "|->  ",
        middle: "|--> ",
        bottom: "|->  ",
      },
      format: :dots_8
    }
    spinners = TTY::Spinner::Multi.new("[:spinner] Initializing database!", opts)

  sp1 = spinners.register "[:spinner] Updating Profile"
  # or sp1 = ::TTY::Spinner.new("[:spinner] one")
  # sp2 = spinners.register "[:spinner] Inputting to the database"
  sleep(0.6)
  sp1.auto_spin
  sleep(0.6)
  # sp2.auto_spin
  # sleep(1)
  

  sp1.success
  sleep(0.6)
  # sp2.success
  
end


def spinnerFunctionDotsForSearchingForDoctorsGoRogue

  opts = {
      style: {
        top: "|->  ",
        middle: "|--> ",
        bottom: "|->  ",
      },
      format: :dots_3
    }
    spinners = TTY::Spinner::Multi.new("[:spinner] Initializing database!", opts)

  sp1 = spinners.register "[:spinner] Populating doctors"
  # or sp1 = ::TTY::Spinner.new("[:spinner] one")
  # sp2 = spinners.register "[:spinner] Inputting to the database"
  sleep(0.6)
  sp1.auto_spin
  sleep(0.6)
  # sp2.auto_spin
  # sleep(1)
  

  sp1.success
  sleep(0.6)
  # sp2.success
  
end

def spinnerFunctionDotsForSearchingForDoctorsByState

  opts = {
      style: {
        top: "|->  ",
        middle: "|--> ",
        bottom: "|->  ",
      },
      format: :dots_5
    }
    spinners = TTY::Spinner::Multi.new("[:spinner] Initializing states!", opts)

  sp1 = spinners.register "[:spinner] Populating doctors"
  # or sp1 = ::TTY::Spinner.new("[:spinner] one")
  # sp2 = spinners.register "[:spinner] Inputting to the database"
  sleep(0.6)
  sp1.auto_spin
  sleep(0.6)
  # sp2.auto_spin
  # sleep(1)
  

  sp1.success
  sleep(0.6)
  # sp2.success
  
end





def spinnerFunctionDotsForSearchingForDoctorsByCity

  opts = {
      style: {
        top: "|->  ",
        middle: "|--> ",
        bottom: "|->  ",
      },
      format: :dots_5
    }
    spinners = TTY::Spinner::Multi.new("[:spinner] Initializing cities!", opts)

  sp1 = spinners.register "[:spinner] Populating doctors"
  # or sp1 = ::TTY::Spinner.new("[:spinner] one")
  # sp2 = spinners.register "[:spinner] Inputting to the database"
  sleep(0.6)
  sp1.auto_spin
  sleep(0.6)
  # sp2.auto_spin
  # sleep(1)
  

  sp1.success
  sleep(0.6)
  # sp2.success
  
end





def spinnerFunctionDotsForSearchingForDoctorsBySpecialty

  opts = {
      style: {
        top: "|->  ",
        middle: "|--> ",
        bottom: "|->  ",
      },
      format: :dots_6
    }
    spinners = TTY::Spinner::Multi.new("[:spinner] Initializing specialties!", opts)

  sp1 = spinners.register "[:spinner] Populating doctors"
  # or sp1 = ::TTY::Spinner.new("[:spinner] one")
  # sp2 = spinners.register "[:spinner] Inputting to the database"
  sleep(0.6)
  sp1.auto_spin
  sleep(0.6)
  # sp2.auto_spin
  # sleep(1)
  

  sp1.success
  sleep(0.6)
  # sp2.success
  
end



def spinnerFunction3

    opts = {
        style: {
          top: "|->  ",
          middle: "|--> ",
          bottom: "|->  ",
        },
        format: :dots_2
      }
      spinners = TTY::Spinner::Multi.new("[:spinner] Encrypting Password!", opts)

    sp1 = spinners.register "[:spinner] Initializing string"
    # or sp1 = ::TTY::Spinner.new("[:spinner] one")
    sp2 = spinners.register "[:spinner] Inputting to the database"
    
    sp1.auto_spin
    sleep(1)
    sp2.auto_spin
    sleep(1)
    
  
    sp1.success
    sp2.success
    
end


def spinnerFunctionForLogin

    opts = {
        style: {
          top: "|->  ",
          middle: "|--> ",
          bottom: "|->  ",
        },
        format: :dots_6
      }
      spinners = TTY::Spinner::Multi.new("[:spinner] Retrieving User Data", opts)

    sp1 = spinners.register "[:spinner] Syncing registry"
    # or sp1 = ::TTY::Spinner.new("[:spinner] one")
    sp2 = spinners.register "[:spinner] Loading into RAM"
    
    sp1.auto_spin
    sleep(0.8)
    sp2.auto_spin
    sleep(0.6)
    
  
    sp1.success
    sp2.success
    
end





def spinnerFunction4

    spinner = TTY::Spinner.new("[:spinner] Loading..", format: :pulse_3)

    spinner.auto_spin # Automatic animation with default interval
    
    sleep(1) # Perform task
    
    spinner.stop('Complete') # Stop animation

end

def spinnerFunction5

    spinner = TTY::Spinner.new("[:spinner] Loading..", format: :pong)

    spinner.auto_spin # Automatic animation with default interval
    
    sleep(1) # Perform task
    
    spinner.stop('Complete') # Stop animation

end