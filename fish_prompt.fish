function preexec --on-event fish_preexec
  set -g _play_command_begin_time (date +%s%3N)
end

function postexec --on-event fish_postexec
  set -l _status $status
  if test -z $_play_command_begin_time
    return
  end

  set -l code
  if test $_status -eq 0
    set_color green
    set code "✔success:$_status"
  else
    set_color red
    set code "✘error:$_status"
  end

  set -l took_time
  set -l millis (echo (date +%s%3N)"-$_play_command_begin_time" | bc)
  if test $millis -ge 10000
    set took_time (echo "$millis/1000" | bc)s
  else if test $millis -ge 1000
    set took_time (echo "scale=2; $millis/1000" | bc)s
  else
    set took_time "$millis""ms"
  end

  echo -s -n $code\ (set_color magenta)\ 󱦟$took_time\n
end

function fish_prompt
  set now_date (set_color cyan)(date +%H:%M:%S)
  set who_n_where (set_color yellow)$USER::(prompt_hostname)
  set pwd (prompt_pwd)
  set enter_mark (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯'

  echo -e -s -n -- $now_date\ $who_n_where\ (set_color white)\|(set_color yellow)\ $pwd\n$enter_mark\ 
  set_color normal
end

