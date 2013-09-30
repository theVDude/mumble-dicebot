require 'pry'

$MAX_DICE = 2**8
$MAX_DIESIZE = 2**32
$NO_LIMITS = false

def get_helptext(command=$0)
  sample = "Punch guy: 4d10  Don't blow up: 1d10~10"
    <<-EOF
Syntax: #{command} <input>

The <input> will be filtered and any occurences of "[m]d<n>[~diff]" will be replaced by rolled dice numbers. [m] is optional and defaults to 1. [~diff] is difficulty and defaults to 6.

Example:             "#{command} #{sample}"
  might evaluate to  "#{substitute(sample.dup)}"
EOF
end  

class Die
  attr_reader :face
  def to_s
    @face.to_s
  end
  def to_i
    @face.to_i
  end
end

class DX < Die
  def initialize(x)
    raise ArgumentError, "Die size (#{x}) too high. Maximum allowed: #{$MAX_DIESIZE}." if (x > $MAX_DIESIZE) unless $NO_LIMITS
    @face = rand(x)+1
  end
end

class DFudge < Die
  def initialize
    @face = rand(3)-1
  end
end

def checkdice(dice,hard)
  wins = 0
  dice.each do |d|
    wins += 1  if d.to_i >= hard
    wins -= 1  if d.to_i == 1 unless hard == 1
  end
  if wins > 1 || wins == 0
    "[#{wins} successes]"
  elsif wins == 1
    "[#{wins} success]"
  elsif wins == -1
    "[#{wins * -1} botch]"
  else
    "[#{wins * -1} botches]"
  end
end

def substitute(str)
  str.gsub!(/(\d*)(d|D)(\d+)~?(\d+)?/) do |m|
    dice = []
    ($1.empty? ? 1 : $1.to_i).times do
      dice.push (DX.new($3.to_i))
      raise ArgumentError, "Too many dice/tokens. Maximum allowed: #{$MAX_DICE}." if (dice.length > $MAX_DICE) unless $NO_LIMITS
    end
    $4.nil? ? hard = 6 : hard = $4.to_i
    successes = checkdice(dice,hard)
    dice.push(successes)
    dice.join(" ")
  end
  str
end

