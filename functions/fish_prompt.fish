# name: jonathan
#
# This theme is based on the jonathan theme from oh-my-zsh
# with some elements of the lambda theme from oh-my-fish
#
# You can override some default options in your config.fish:
#  set -g __jonathan_prompt_char '><>'
#  set -g __jonathan_prompt_char_rewrite_root no
#  set -g __jonathan_main_color 80babf
#  set -g __jonathan_secondary_color 666666
#  set -g __jonathan_tertiary_color white
#  set -g __jonathan_use_shrunk_pwd no
#  set -g __jonathan_pwd_color abc48d
#  set -g __jonathan_pwd_crop_color 555555
#  set -g __jonathan_print_time yes
#  set -g __jonathan_time_color d9bb68
#  set -g __jonathan_print_git yes
#  set -g __jonathan_print_env yes
#  set -g __jonathan_env_color 93879c
#  set -g __jonathan_print_multiplexer yes
#  set -g __jonathan_multiplexer_color d17c3d
#  set -g __jonathan_print_user yes
#  set -g __jonathan_user_color 80babf
#  set -g __jonathan_print_hostname yes
#  set -g __jonathan_hostname_color abc48d
#  set -g __jonathan_minimum_midbar_length 3
#  set -g __jonathan_show_pwd_beginning_on_crop 15
#
#  set -g __fish_git_prompt_char_stateseparator ' '
#  set -g __fish_git_prompt_color 80babf
#  set -g __fish_git_prompt_color_flags df5f00
#  set -g __fish_git_prompt_color_prefix white
#  set -g __jonathan_git_prompt_showdirtystate yes
#  set -g __jonathan_git_prompt_showuntrackedfiles yes
#  set -g __jonathan_git_prompt_showstashstate yes
#  set -g __jonathan_git_prompt_show_informative_status yes

function fish_prompt
  
  # Cache exit status
  set -l last_status $status

  set -l normal (set_color normal)
  set -l white (set_color FFFFFF)
  
  __jonathan_prompt_settings
  # Setup colors
  set -l main_color (set_color $__jonathan_main_color)
  set -l secondary_color (set_color $__jonathan_secondary_color)
  set -l tertiary_color (set_color $__jonathan_tertiary_color)
  set -l pwd_color (set_color $__jonathan_pwd_color)
  set -l pwd_crop_color (set_color $__jonathan_pwd_crop_color)
  set -l time_color (set_color $__jonathan_time_color)
  set -l env_color (set_color $__jonathan_env_color)
  set -l multiplexer_color (set_color $__jonathan_multiplexer_color)
  set -l user_color (set_color $__jonathan_user_color)
  set -l hostname_color (set_color $__jonathan_hostname_color)

  if test $COLUMNS -lt 20
    echo -n $main_color'>' $normal
    return 1
  end

  # Just compute these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (echo $hostname)
  end

  set -l term_width $COLUMNS
  set -ge __jonathan_hide_right_side

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

  if test $__jonathan_use_shrunk_pwd = 'yes'
    set current_pwd (prompt_pwd)
  else
    set current_pwd (pwd|sed "s=$HOME=~=")
  end
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

  set -l min_length $__jonathan_minimum_midbar_length
  if test $fill_length -lt $min_length
    set -l to_remove (math "$min_length-$fill_length")
    
    set -l crop (math $to_remove+(math "3+1")) # 3 for '...' +1 for the cut cmd
    set -l tmp_pwd (echo $current_pwd | cut -c $crop-)
    set formatted_pwd '...'$tmp_pwd
    set pwd_length (string length $formatted_pwd)
    if test $pwd_length -gt 3
      set formatted_pwd $pwd_crop_color'...'$pwd_color$tmp_pwd
      # we've got enough space to show the beginning of the pwd (twice the characters to show at the beginning)
      if test $__jonathan_show_pwd_beginning_on_crop -gt 0; and test $pwd_length -gt (math "$__jonathan_show_pwd_beginning_on_crop*2")
        set formatted_pwd $pwd_color(echo $current_pwd | cut -c -$__jonathan_show_pwd_beginning_on_crop)$pwd_crop_color'...'$pwd_color(echo $current_pwd | cut -c (math $__jonathan_show_pwd_beginning_on_crop+$crop)-)
      end
      set fill_length $min_length
    else # If the width is too small to even crop hide stuff
      set formatted_pwd $current_pwd
      set pwd_length (string length $formatted_pwd)
      set fill_length (__jonathan_fill_length $term_width 0 0 $pwd_length 0 4)
      set -l to_remove (math "$min_length-$fill_length")
      
      if test $to_remove -gt 0
        set -l crop (math $to_remove+(math "3+1")) # 3 for '...' +1 for the cut cmd
        set -l tmp_pwd (echo $current_pwd | cut -c $crop-)
        set formatted_pwd '...'$tmp_pwd
        set pwd_length (string length $formatted_pwd)
        
        set fill_length (__jonathan_fill_length $term_width 0 0 $pwd_length 0 4)
      end
      set -g __jonathan_hide_right_side

    end
  end

  # Line 1
  # left side
  echo -n $main_color'╭─'
  if not set -q __jonathan_hide_right_side
    echo -n $secondary_color'('
  end
  echo -n $pwd_color$formatted_pwd
  if not set -q __jonathan_hide_right_side
    echo -n $secondary_color')'
  end
  
  # fill in
  if test $fill_length -gt 0
    echo -n $main_color(string repeat -n$fill_length ─)
  end

  #TODO Don't print right side if size too long
  #right side
  if not set -q __jonathan_hide_right_side
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
  end
  echo -n $main_color'─╮'
  echo

  # Line 2
  echo -n $main_color'╰'
  set -g __jonathan_left_second_line_length 1
  set -l git_length (string length (__fish_git_prompt $sep"on %s" | sed 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'"'"'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g')) # computed beforehand to know if I need to print the parentheses in small windows
  set -l git_length (math "$git_length-5")

  # support for virtual env name
  if set -q VIRTUAL_ENV; and test $__jonathan_print_env = 'yes'; and test $COLUMNS -gt 50
    set -l env '{'(basename "$VIRTUAL_ENV")'}'
    set -l env_length (string length $env)
    set -g __jonathan_left_second_line_length (math "$__jonathan_left_second_line_length+$env_length")
    echo -n $env_color$env
  end
  if test \( $__jonathan_print_time = 'yes' -a $COLUMNS -gt 50 \) -o \( $__jonathan_print_git = 'yes' -a $git_length -gt 0 \)
    echo -n $main_color'─('
    set -g __jonathan_left_second_line_length (math "$__jonathan_left_second_line_length+3") # -()
    if test $__jonathan_print_time = 'yes'; and test $COLUMNS -gt 50
      set -g __jonathan_left_second_line_length (math "$__jonathan_left_second_line_length+8")
      echo -n $time_color(date +%H:%M:%S)
    end
    set -l sep ''
    if test $__jonathan_print_time = 'yes'; and test $__jonathan_print_git = 'yes'
      set -g __jonathan_left_second_line_length (math "$__jonathan_left_second_line_length+1")
      set sep ' '
    end
    if test $__jonathan_print_git = 'yes'
      set -g __jonathan_left_second_line_length (math "$__jonathan_left_second_line_length+$git_length")
      __fish_git_prompt $sep"on %s"
    end
    echo -n $main_color')'
  end
  set -l promptchar_length (string length $__jonathan_prompt_char)
  set -g __jonathan_left_second_line_length (math "$__jonathan_left_second_line_length+1")
  set -g __jonathan_left_second_line_length (math "$promptchar_length+$__jonathan_left_second_line_length")
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

  if not set -q __jonathan_use_shrunk_pwd
    set -g __jonathan_use_shrunk_pwd no
  end
  if not set -q __jonathan_pwd_color
    set -g __jonathan_pwd_color abc48d
  end
  if not set -q __jonathan_pwd_crop_color
    set -g __jonathan_pwd_crop_color 555555
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
  if not set -q __jonathan_print_env
    set -g __jonathan_print_env yes
  end
  if not set -q __jonathan_env_color
    set -g __jonathan_env_color 93879c
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
  if not set -q __jonathan_minimum_midbar_length
    set -g __jonathan_minimum_midbar_length 3
  end
  if not set -q __jonathan_show_pwd_beginning_on_crop
    set -g __jonathan_show_pwd_beginning_on_crop 15
  end

  # Configure __fish_git_prompt
  if not set -q __fish_git_prompt_char_stateseparator
    set -g __fish_git_prompt_char_stateseparator ' '
  end
  if not set -q __fish_git_prompt_color
    set -g __fish_git_prompt_color 80babf
  end
  if not set -q __fish_git_prompt_color_flags
    set -g __fish_git_prompt_color_flags df5f00
  end
  if not set -q __fish_git_prompt_color_prefix
    set -g __fish_git_prompt_color_prefix white
  end
  if not set -q __jonathan_git_prompt_showdirtystate; or test $__jonathan_git_prompt_showdirtystate = 'yes'
    set -g __fish_git_prompt_showdirtystate true
  end
  if not set -q __jonathan_git_prompt_showuntrackedfiles; or test $__jonathan_git_prompt_showuntrackedfiles = 'yes'
    set -g __fish_git_prompt_showuntrackedfiles true
  end
  if not set -q __jonathan_git_prompt_showstashstate; or test $__jonathan_git_prompt_showstashstate = 'yes'
    set -g __fish_git_prompt_showstashstate true
  end
  if not set -q __jonathan_git_prompt_show_informative_status; or test $__jonathan_git_prompt_show_informative_status = 'yes'
    set -g __fish_git_prompt_show_informative_status False
  end

end
