# name: jonathan
#
# This theme is based on the jonathan theme from oh-my-zsh
# with some elements of the lambda theme from oh-my-fish
#
# You can override some default options in your config.fish:
#  set -g __jonathan_prompt_char '\'ω\''   # default='><>'
#  set -g __jonathan_prompt_char_rewrite_root yes   # default=no
#  set -g __jonathan_main_color <color>   # defaut=80babf
#  set -g __jonathan_secondary_color <color>   # defaut=666666
#  set -g __jonathan_tertiary_color <color>   # defaut=white
#  set -g __jonathan_pwd_color <color>   # defaut=abc48d
#  set -g __jonathan_print_time no   # defaut=yes
#  set -g __jonathan_time_color <color>   # defaut=d9bb68
#  set -g __jonathan_print_git no   # defaut=yes
#  set -g __jonathan_print_multiplexer no   # defaut=yes
#  set -g __jonathan_multiplexer_color <color>   # defaut=d17c3d
#  set -g __jonathan_print_user no   # defaut=yes
#  set -g __jonathan_user_color <color>   # defaut=80babf
#  set -g __jonathan_print_hostname no   # defaut=yes
#  set -g __jonathan_hostname_color <color>   # defaut=abc48d

function fish_prompt
  
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  __jonathan_prompt_settings

  # Setup colors

  set -l main_color (set_color $__jonathan_main_color)
  set -l secondary_color (set_color $__jonathan_secondary_color)
  set -l tertiary_color (set_color $__jonathan_tertiary_color)
  set -l pwd_color (set_color $__jonathan_pwd_color)
  set -l datetime_color (set_color $__jonathan_time_color)
  set -l multiplexer_color (set_color $__jonathan_multiplexer_color)
  set -l user_color (set_color $__jonathan_user_color)
  set -l hostname_color (set_color $__jonathan_hostname_color)

  set -l normal (set_color normal)
  set -l white (set_color FFFFFF)
  set -l turquoise (set_color 5fdfff)

  # Configure __fish_git_prompt
  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_color 80babf
  set -g __fish_git_prompt_color_flags df5f00
  set -g __fish_git_prompt_color_prefix white
  set -g __fish_git_prompt_color_suffix white
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showstashstate true
  set -g __fish_git_prompt_show_informative_status true 

  set -l term_width $COLUMNS


  set -l current_user ''
  set -l user_length 0
  if test $__jonathan_print_user = 'yes'
    set current_user (whoami)
    set user_length (string length $current_user)
  end


  set -l hard_hostname ''
  set -l hard_hostname_length 0
  if test $__jonathan_print_hostname = 'yes'
    set hard_hostname $__fish_prompt_hostname':'(tty|sed -e "s:/dev/::")
    set hard_hostname_length (string length $hard_hostname)
  end

  set -l current_pwd (pwd|sed "s=$HOME=~=")
  set -l formatted_pwd (echo $current_pwd)
  set -l pwd_length (string length $formatted_pwd)

  set -l tmux_prompt ''
  set -l tmux_prompt_length 0
  if test $__jonathan_print_multiplexer = 'yes'
    set -l sep ''
    if test $__jonathan_print_user = 'yes'; or test $__jonathan_print_hostname = 'yes'
      set sep '#'
    end
    set tmux_prompt (__jonathan_tmux_prompt)$sep
    set tmux_prompt_length (string length $tmux_prompt)
  end

  # --()( )--
  set -l decoration_length 0
  if test $__jonathan_print_user = 'yes'; or test $__jonathan_print_hostname = 'yes'; or test $__jonathan_print_multiplexer = 'yes';
    if test $__jonathan_print_user = 'yes'; and test $__jonathan_print_hostname = 'yes'
      set decoration_length 9
    else
      set decoration_length 8
    end
  else
    set decoration_length 6
  end
  set -l fill_length (__jonathan_fill_length $term_width $user_length $hard_hostname_length $pwd_length $tmux_prompt_length $decoration_length)

  if test $fill_length -lt 3
    set -l to_remove (math "0-$fill_length")
    set to_remove (math "$to_remove+7")
    set formatted_pwd '...'(echo $current_pwd | cut -c $to_remove-)
    set pwd_length (string length $formatted_pwd)

    set fill_length (math "$fill_length-$to_remove")
  end

  # Line 1
  # left side
  echo -n $main_color'╭─'$secondary_color'('$pwd_color$formatted_pwd$secondary_color')'
  
  # fill in
  if test $fill_length -gt 0
    echo -n $main_color(string repeat -n$fill_length ─)
  end

  #right side
  if test $__jonathan_print_user = 'yes'; or test $__jonathan_print_hostname = 'yes'; or test $__jonathan_print_multiplexer = 'yes';
    echo -n $secondary_color'('
    echo -n $multiplexer_color$tmux_prompt
    echo -n $user_color$current_user
    if test $__jonathan_print_user = 'yes'; and test $__jonathan_print_hostname = 'yes'
      echo -n $secondary_color'@'
    end
    echo -n $hostname_color$hard_hostname
    echo -n $secondary_color')'
  end
  echo -n $main_color'─╮'
  echo

  # Line 2
  echo -n $main_color'╰'
  # support for virtual env name
  if set -q VIRTUAL_ENV
      echo -n "($turquoise"(basename "$VIRTUAL_ENV")"$white)"
  end
  if test $__jonathan_print_time = 'yes'; or test $__jonathan_print_git = 'yes'
    echo -n $main_color'─('
    if test $__jonathan_print_time = 'yes'
      echo -n $datetime_color(date +%H:%M:%S)
    end
    if test $__jonathan_print_time = 'yes'; and test $__jonathan_print_git = 'yes'
      echo -n ' '
    end
    if test $__jonathan_print_git = 'yes'
      __fish_git_prompt "on %s"
    end
    echo -n $main_color')'
  end
  echo -n $main_color'─'$__jonathan_prompt_char $normal
end

# Helper methods

function __jonathan_tmux_prompt
  set multiplexer (__jonathan_is_multiplexed)

  switch $multiplexer
    case screen
      set pane (__jonathan_get_screen_window)
    case tmux
      set pane (__jonathan_get_tmux_window)
  end

  if test -z $pane
    echo -n ""
  else
    echo -n $pane
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

function __jonathan_fill_length -a t -a u -a hh -a p -a tp -a d
  set -l l1 (math "$d + $tp")
  set -l l2 (math "$hh + $p")
  set -l l3 (math "$l1 + $u")
  set -l length (math "$l2 + $l3")

  set -l fill_length (math "$t - $length")
  echo -n $fill_length
end

######### SETTINGS
function __jonathan_prompt_settings
  if not set -q __jonathan_prompt_char_rewrite_root
    set -g __jonathan_prompt_char_rewrite_root no
  end
  switch (id -u)
    case 0
      if test $__jonathan_prompt_char_rewrite_root = 'no'
        set -g __jonathan_prompt_char '#'
      end
    case '*'
      if not set -q __jonathan_prompt_char
        set -g __jonathan_prompt_char '><>'
      end
  end

  if not set -q __jonathan_main_color
    set -g __jonathan_main_color 80babf
  end
  if not set -q __jonathan_secondary_color
    set -g __jonathan_secondary_color 666666
  end
  if not set -q __jonathan_tertiary_color
    set -g __jonathan_tertiary_color white
  end

  if not set -q __jonathan_pwd_color
    set -g __jonathan_pwd_color abc48d
  end
  if not set -q __jonathan_print_time
    set -g __jonathan_print_time yes
  end
  if not set -q __jonathan_time_color
    set -g __jonathan_time_color d9bb68
  end
  if not set -q __jonathan_print_git
    set -g __jonathan_print_git yes
  end

  if not set -q __jonathan_print_multiplexer
    set -g __jonathan_print_multiplexer yes
  end
  if not set -q __jonathan_multiplexer_color
    set -g __jonathan_multiplexer_color d17c3d
  end
  if not set -q __jonathan_print_user
    set -g __jonathan_print_user yes
  end
  if not set -q __jonathan_user_color
    set -g __jonathan_user_color 80babf
  end
  if not set -q __jonathan_print_hostname
    set -g __jonathan_print_hostname yes
  end
  if not set -q __jonathan_hostname_color
    set -g __jonathan_hostname_color abc48d
  end

end