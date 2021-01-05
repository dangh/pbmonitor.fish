function pbmonitor-init
  ~/.config/fish/conf.d/pbmonitor | while read --null --local clipboard
    emit clipboard_change "$clipboard"

    # exit if monitor is the last process
    set --query --universal pbmonitor_autokill \
      && test (count (pgrep fish)) -eq 0 \
      && killall -9 pbmonitor
  end
end

# ensure only one monitor is running
set --local pidfile (dirname (mktemp -u))/pbmonitor.pid
if test -f $pidfile
  set --local pid (command cat $pidfile)
  kill -0 "$pid" 2>/dev/null && exit
end
printf %self > $pidfile

nohup fish --private --command 'pbmonitor-init' >/dev/null &
disown
