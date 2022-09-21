function pbmonitor-loop
  if type -q -f pbmonitor
    command pbmonitor | while read -l -z clip
      emit clipboard_change "$clip"
    end
  else
    while pbpaste | read -l -z clip
      if test "$clip0" != "$clip"
        set -f clip0 "$clip"
        emit clipboard_change "$clip"
      end
      # exit if this is the last fish process
      test (count (pgrep -U (id -u) fish)) -eq 0 \
        && ! kill -0 (ps -o ppid= -p $fish_pid) \
        && break
      sleep 0.1
    end
  end
end

status is-interactive || exit

function _pbmonitor_refresh -e pbmonitor_install -e pbmonitor_update -e pbmonitor_uninstall
  flock -u {$TMPDIR}pbmonitor >/dev/null 2>&1 &
  pkill -9 -U (id -u) pbmonitor &
end

nohup fish -P -c 'flock {$TMPDIR}pbmonitor pbmonitor-loop' >/dev/null 2>&1 &
disown
