function fish_right_prompt 
  set -g __fish_print_cmd_duration yes
  set -g __fish_print_date yes

  set -l exit_code $status
  set -l cmd_duration $CMD_DURATION

  if test $exit_code -ne 0
    set_color red
  else
    set_color abc48d
  end
  printf '%d ↵' $exit_code
  if [ "$__fish_print_cmd_duration" = 'yes' ]
    if test $cmd_duration -ge 5000
      set_color brcyan
    else
      set_color blue
    end
    printf '(%s)' (__print_duration $cmd_duration)
  end
  set_color 80babf
  if [ "$__fish_print_date" = 'yes' ]
    echo -n '('
    set_color d9bb68
    echo -n (date '+%a,%B%d')
    set_color 80babf
    echo -n ')'
  end
  echo -n '─╯'
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

