# You can override some default options in your config.fish:
#
#  set -g __jonathan_print_greeting no
#  set -g __jonathan_print_greeting_on_multiplexer no
#  set -g __jonathan_greeting_color FFFFFF
#  set -g __jonathan_greeting_msg <greeting message>

function fish_greeting
  __jonathan_greeting_settings
  if test $__jonathan_print_greeting_on_multiplexer = 'yes'; or not test (__jonathan_is_multiplexed) = "tmux"

    set -l greeting_color (set_color $__jonathan_greeting_color)

    if [ "$__jonathan_print_greeting" = 'yes' ]
      echo $greeting_color$__jonathan_greeting_msg
    end
  end
end

function __jonathan_greeting_settings
  if not set -q __jonathan_print_greeting
    set -g __jonathan_print_greeting no
  end
  if not set -q __jonathan_print_greeting_on_multiplexer
    set -g __jonathan_print_greeting_on_multiplexer no
  end
  if not set -q __jonathan_greeting_color
    set -g __jonathan_greeting_color FFFFFF
  end
  if not set -q __jonathan_greeting_msg
    set -g __jonathan_greeting_msg "                                     ﾊﾟﾀﾊﾟﾀ   (⌒　(⌒)
    ┏┳━━┳━┳┳━━┳━━┳┓┏┳━━┳━┳┓       `∧∧         (⌒⌒ ⌒)
    ┃┃┏┓┃ ┃┃┏┓┣┓┏┫┗┛┃┏┓┃ ┃┃       (`･ω)  ／￣＼(⌒ (⌒)
  ┏━┛┃┗┛┃┃ ┃┣┫┃┃┃┃┏┓┃┣┫┃┃ ┃       ( ⊃⊃＝)     ｜(⌒⌒)
  ┗━━┻━━┻┻━┻┛┗┛┗┛┗┛┗┻┛┗┻┻━┛       と_)_) ＼＿／ (⌒)
                                               ＿＿＿
     Two line prompt                        ＜･)////＞＜(
       fish theme for your                    〔￣￣〕
         overloaded terminal                   |_━_|"
  end
end


function __jonathan_get_tmux_window
  tmux lsw | grep active | sed 's/\*.*$//g;s/: / /1' | awk '{ print $2 "-" $1 }' -
end

function __jonathan_get_screen_window
  set initial (screen -Q windows; screen -Q echo "")
  set middle (echo $initial | sed 's/  /\n/g' | grep '\*' | sed 's/\*\$ / /g')
  echo $middle | awk '{ print $2 "-" $1 }' -
end

function __jonathan_is_multiplexed
  set multiplexer ""
  if test -z $TMUX
  else
    set multiplexer "tmux"
  end
  if test -z $WINDOW
  else
    set multiplexer "screen"
  end
  echo $multiplexer
end