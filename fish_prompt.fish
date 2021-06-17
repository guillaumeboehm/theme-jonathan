# name: jonathan
#
# This theme is based on the jonathan theme from oh-my-zsh
# with some elements of the lambda theme from oh-my-fish
#
# You can override some default options in your config.fish:
#   set -g __fish_prompt_char '\'ω\''   # default='>'
#   set -g __fish_print_greeting yes   # default=no
#   set -g __fish_print_cmd_duration no   # default=yes
#   set -g __fish_print_date no   # default=yes

function fish_prompt
  
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
	      set -g __fish_prompt_char '#'
      case '*'
	      set -g __fish_prompt_char '>'
    end
  end

  # Setup colors
  set -l normal (set_color normal)
  set -l white (set_color FFFFFF)
  set -l lightgray (set_color 666666)
  set -l turquoise (set_color 5fdfff)
  set -l orange (set_color df5f00)
  set -l hotpink (set_color df005f)
  set -l blue (set_color blue)
  set -l cyan (set_color 80babf)
  set -l limegreen (set_color 87ff00)
  set -l gudgreen (set_color abc48d)
  set -l purple (set_color af5fff)
  set -l yellow (set_color d9bb68)

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

  #set -l term_width (math $COLUMNS - 1)
  set -l term_width $COLUMNS

  set -l current_user (whoami)
  set -l user_length (string length $current_user)

  set -l hard_hostname $__fish_prompt_hostname':'(tty|sed -e "s:/dev/::")
  set -l hard_hostname_length (string length $hard_hostname)

  set -l current_pwd (pwd|sed "s=$HOME=~=")
  set -l formatted_pwd (echo $current_pwd)
  set -l pwd_length (string length $formatted_pwd)

  set -l tmux_prompt $__jonathan_tmux_prompt
  set -l tmux_prompt_length (string length $tmux_prompt)

  set -l decoration_length (echo -n '--()( )--' | wc -m)
  set -l fill_length (__jonathan_fill_length $term_width $user_length $hard_hostname_length $pwd_length $tmux_prompt_length $decoration_length)

  if test $fill_length -lt 3
    set to_remove (math "0-$fill_length")
    set to_remove (math "$to_remove+7")
    set formatted_pwd '...'(echo $current_pwd | cut -c $to_remove-)
    set pwd_length (string length $formatted_pwd)

    set fill_length (__jonathan_fill_length $term_width $user_length $hard_hostname_length $pwd_length $tmux_prompt_length $decoration_length)
  end

  # Line 1
  # left side
  echo -n $cyan'╭─'$lightgray'('$gudgreen$formatted_pwd$lightgray')'
  
  # fill in
  if test $fill_length -gt 0
    echo -n $cyan(string repeat -n$fill_length ─)
  end

  #right side
  echo -n $lightgray'('
  echo -n $tmux_prompt
  echo -n $cyan$current_user$lightgray'@'$gudgreen$hard_hostname
  echo -n $lightgray')'$cyan'─╮'
  echo

  # Line 2
  echo -n $cyan'╰'
  # support for virtual env name
  if set -q VIRTUAL_ENV
      echo -n "($turquoise"(basename "$VIRTUAL_ENV")"$white)"
  end
  echo -n $cyan'─('
  echo -n $yellow(date +%H:%M:%S)
  __fish_git_prompt " on %s"
  echo -n $cyan')'
  echo -n $cyan'─'$__fish_prompt_char $normal
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

  set_color 666666
  if test -z $pane
    echo -n ""
  else
    echo -n $pane' | '
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