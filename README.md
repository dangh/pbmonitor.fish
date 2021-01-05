# pbmonitor.fish

### Installation

```fish
fisher install dangh/pbmonitor.fish
```

### Usage

```fish
function my-monitor --on-event clipboard_change --argument-names content
  echo clipboard changed: $content
end
```
