require 'pry'
require 'libdice'

# Dirty right now. Need to move actual command logic out and just use this
# to actually grab the command name.

def getcommand(msg)
  msg.message =~ /#{$COMMAND}(\w+)/
  commandused = $1
  case commandused
  when 'roll', 'nobotch', 'special'
    if msg.message =~ /#{commandused}\s*help\s*$/
      # show command help
      "#{HELP_TEXT(commandused)}"
    elsif msg.message =~ /#{commandused}\s+(.*)\s*$/
      begin
        "<b>#{$names[msg.actor]}: </b>#{substitute($1,commandused)}"
      rescue ArgumentError => e
        "\"<b>Error</b>: #{e}</b>\",#{[msg.actor]}"
      end
    end
      
  when 'help'
    "<br>I'm here to make your V20 playing much more pleasureable!<br><br>
     Commands:<br>
     <b>#{$COMMAND}roll</b> &lt;input&gt; - Regular ol' dice rollin!<br>
     <b>#{$COMMAND}nobotch</b> &lt;input&gt; - Roll dice where 1s don't botch!<br>
     <b>#{$COMMAND}special</b> &lt;input&gt; - Make those 10s count DOUBLE!<br><br>

     use '<b>help</b>' as the input for more information on any command!"
  else
    #wat r u doin dolan pls
    "wat r u doin stahp"
  end
end
