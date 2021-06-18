# You can override some default options in your config.fish:
#
#  set -g __jonathan_print_greeting yes   # default=no
#  set -g __jonathan_greeting_color <color> # default=FFFFFF
#  set -g __jonathan_greeting_msg <greeting message>

function fish_greeting
  
  __jonathan_greeting_settings

  set -l greeting_color (set_color $__jonathan_greeting_color)

  if [ "$__jonathan_print_greeting" = 'yes' ]
    echo $greeting_color$__jonathan_greeting_msg
  end
end

function __jonathan_greeting_settings
  if not set -q __jonathan_print_greeting
    set -g __jonathan_print_greeting no
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
   Double prompt line                       ＜･)////＞＜(
    fish theme for your                      〔￣￣〕
     overloaded terminal                      |_━_|"
  end
end