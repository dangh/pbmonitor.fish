function pbmonitor-fish
  set --local pidfile {$TMPDIR}pbmonitor.pid
  pgrep -qF "$pidfile" 2>/dev/null && return
  echo $fish_pid > $pidfile

  set --local clip0
  while pbpaste | read --null --local clip
    if test "$clip0" != "$clip"
      set clip0 "$clip"
      emit clipboard_change "$clip"
    end

    # exit if this is the last fish process
    test (count (pgrep -U (id -u) fish)) -eq 0 \
      && ! kill -0 (ps -o ppid= -p $fish_pid) \
      && break

    sleep 0.1
  end
end

function pbmonitor-native
  set --local pidfile {$TMPDIR}pbmonitor.pid
  pgrep -qF "$pidfile" 2>/dev/null && return
  echo $fish_pid > $pidfile
  command pbmonitor | while read --null --local clip
    emit clipboard_change "$clip"
  end
end

status is-interactive || exit

function _pbmonitor_refresh --on-event pbmonitor_install --on-event pbmonitor_update --on-event pbmonitor_uninstall
  pkill -9 -F "$pidfile" >/dev/null 2>&1 &
  pkill -9 -U (id -u) pbmonitor &
end

nohup fish --private --command 'which pbmonitor && pbmonitor-native || pbmonitor-fish' >/dev/null 2>&1 &
disown
