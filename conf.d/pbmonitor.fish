set -g PBMONITOR_LOCKFILE $TMPDIR/pbmonitor.lock

function pbmonitor -a action -d 'start pbmonitor'
  switch $action
  case restart
    pkill -x pbmonitor >/dev/null 2>&1
  end

  # use nohup to leave this child process running in the background after this process terminated
  nohup fish -P -c '
    if shlock -f '$PBMONITOR_LOCKFILE' -p $fish_pid
      command pbmonitor | while read -l -z clip
        emit clipboard_change "$clip"
      end
    end
  ' >/dev/null 2>&1 &

  # hide warning when terminate this process
  disown
end

status is-interactive || exit

pbmonitor
