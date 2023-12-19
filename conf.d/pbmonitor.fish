status is-interactive || exit

nohup fish -P -c '
  if shlock -f {$TMPDIR}pbmonitor.lock -p $fish_pid
    command pbmonitor | while read -l -z clip
      emit clipboard_change "$clip"
    end
  end
' >/dev/null 2>&1 &
disown
