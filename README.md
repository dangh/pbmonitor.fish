# pbmonitor.fish

### Installation

```fish
brew install dangh/formulae/pbmonitor
fisher install dangh/pbmonitor.fish
```

### Usage

Put your monitoring function in `~/.config/fish/conf.d/` so it can autoload when fish started.

```fish
function my-monitor --on-event clipboard_change --argument-names content
  echo clipboard changed: $content
end
```

### Limitation

Fish events are not cross-process which mean your functions in other processes other than the background one spawned by this plugin will not be notified.
A possible workaround is storing the clipboard content in the universal scope, and watching for that variable.

```fish
# ~/.config/fish/conf.d/clipboard-broadcast.fish
function clipboard-broadcast --on-event clipboard_change --argument-names content
  set -U clipboard_do_not_read_xxx $content
end

# in other places, eg ~/.config/fish/functions/clipboard-listener.fish
function clipboard-listener --on-variable clipboard_do_not_read_xxx
  # process
end
```
