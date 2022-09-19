function pbmonitor-fish
  set -l pidfile {$TMPDIR}pbmonitor.pid
  pgrep -qF "$pidfile" 2>/dev/null && return
  echo $fish_pid > $pidfile

  set -l clip0
  while pbpaste | read -l -z clip
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
  set -l pidfile {$TMPDIR}pbmonitor.pid
  pgrep -qF "$pidfile" 2>/dev/null && return
  echo $fish_pid > $pidfile
  command pbmonitor | while read -l -z clip
    emit clipboard_change "$clip"
  end
end

status is-interactive || exit

function _pbmonitor_refresh -e pbmonitor_install -e pbmonitor_update -e pbmonitor_uninstall
  pkill -9 -F "$pidfile" >/dev/null 2>&1 &
  pkill -9 -U (id -u) pbmonitor &
end

nohup fish -P -c 'which pbmonitor && pbmonitor-native || pbmonitor-fish' >/dev/null 2>&1 &
disown
