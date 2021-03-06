# You can override some default options in your config.fish:
#
# set -g __jonathan_print_cmd_duration yes
# set -g __jonathan_cmd_duration_short_color 008888
# set -g __jonathan_cmd_duration_long_color cc2200
#
# set -g __jonathan_print_return_code yes
# set -g __jonathan_return_code_success_color abc48d
# set -g __jonathan_return_code_error_color red
#
# set -g __jonathan_print_date yes
# set -g __jonathan_date_format '+%a,%B%d'
# set -g __jonathan_date_color d9bb68
#
# set -g __jonathan_print_bg_procs yes
# set -g __jonathan_bg_procs_color 678572

function fish_right_prompt 
  # Settings
  __jonathan_right_prompt_settings
  ####
    
  set -l exit_code $status


  if test $COLUMNS -lt 20

    if [ "$__jonathan_print_return_code" = 'yes' ]
      if test $exit_code -ne 0
        set_color $__jonathan_return_code_error_color
      else
        set_color $__jonathan_return_code_success_color
      end
      printf '%d↵' $exit_code
    end
    return 1
  end

  # return code
  if [ "$__jonathan_print_return_code" = 'yes' ]
    if test $exit_code -ne 0
      set_color $__jonathan_return_code_error_color
    else
      set_color $__jonathan_return_code_success_color
    end
    printf '%d ↵' $exit_code
  end

  set -l approximate_length (math "$__jonathan_left_second_line_length+30")
  if test (math "$COLUMNS/$approximate_length") -gt 1.5 # a bit random / to think through
    # cmd duration
    if [ "$__jonathan_print_cmd_duration" = 'yes' ]
      set -l cmd_duration $CMD_DURATION
      if test $cmd_duration -ge 5000
        set_color $__jonathan_cmd_duration_long_color
      else
        set_color $__jonathan_cmd_duration_short_color
      end
      printf '(%s)' (__print_duration $cmd_duration)
    end

    set_color $__jonathan_main_color
    # date
    if [ "$__jonathan_print_date" = 'yes' ]
      echo -n '('
      set_color $__jonathan_date_color
      echo -n (date $__jonathan_date_format)
      set_color $__jonathan_main_color
      echo -n ')'
    end
    if test $__jonathan_print_date = 'no'; and test $__jonathan_print_cmd_duration = 'no'
      echo -n '╰'
    else
      echo -n '─'
    end
    if test $__jonathan_print_bg_procs = 'yes'
      set -l bg_procs (__jonathan_bg_procs)
      if test $bg_procs -ne 0
        echo -n '('
        set_color $__jonathan_bg_procs_color
        echo -n "$bg_procs&"
        set_color $__jonathan_main_color
        echo -n ')'
      end
    end
  else
    set_color $__jonathan_main_color
    echo -n '╰'
  end
  set_color $__jonathan_main_color
  echo -n '╯'
  set_color normal
end


function __print_duration
  set -l duration $argv[1]
 
  set -l millis  (math $duration % 1000)
  set -l seconds (math -s0 $duration / 1000 % 60)
  set -l minutes (math -s0 $duration / 60000 % 60)
  set -l hours   (math -s0 $duration / 3600000 % 60)
 
  if test $duration -lt 60000;
    # Below a minute
    printf "%d.%03ds\n" $seconds $millis
  else if test $duration -lt 3600000;
    # Below a hour
    printf "%02d:%02d.%03d\n" $minutes $seconds $millis
  else
    # Everything else
    printf "%02d:%02d:%02d.%03d\n" $hours $minutes $seconds $millis
  end
end
function _convertsecs
  printf "%02d:%02d:%02d\n" (math -s0 $argv[1] / 3600) (math -s0 (math $argv[1] \% 3600) / 60) (math -s0 $argv[1] \% 60)
end

function __jonathan_bg_procs
  set -l bg_procs (jobs -p | wc -l)
  echo -n $bg_procs
end

function __jonathan_right_prompt_settings
  if not set -q __jonathan_print_cmd_duration
    set -g __jonathan_print_cmd_duration yes
  end
  if not set -q __jonathan_cmd_duration_short_color
    set -g __jonathan_cmd_duration_short_color 008888
  end
  if not set -q __jonathan_cmd_duration_long_color
    set -g __jonathan_cmd_duration_long_color cc2200
  end
    
  if not set -q __jonathan_print_return_code
    set -g __jonathan_print_return_code yes
  end
  if not set -q __jonathan_return_code_success_color
    set -g __jonathan_return_code_success_color abc48d
  end
  if not set -q __jonathan_return_code_error_color
    set -g __jonathan_return_code_error_color red
  end
    
  if not set -q __jonathan_print_date
    set -g __jonathan_print_date yes
  end
  if not set -q __jonathan_date_format
    set -g __jonathan_date_format '+%a,%B%d'
  end
  if not set -q __jonathan_date_color
    set -g __jonathan_date_color d9bb68
  end
  if not set -q __jonathan_print_bg_procs
    set -g __jonathan_print_bg_procs yes
  end
  if not set -q __jonathan_bg_procs_color
    set -g __jonathan_bg_procs_color 678572
  end
end