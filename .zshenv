# Read by EVERY zsh (interactive or not), before .zshrc. Keep it to environment
# only -- no output, no prompts.
#
# Everything here is guarded, so this one file is safe on every machine: a box
# without the tool just skips its line. NOTE that .zshrc later does a hard
# `export PATH="$HOME/bin:..."` that discards what is set here, so .zshrc
# re-adds the pieces it needs; see the comment there.

# Userspace node (console_reference scheduler / usage scraper / ConsoleArtisan e2e)
[ -d "$HOME/.local/node/bin" ] && export PATH="$HOME/.local/node/bin:$PATH"

# Userspace real Chrome, for headless work on boxes with no system Chrome
[ -x "$HOME/.local/chrome/opt/google/chrome/chrome" ] && \
    export CHROME_EXECUTABLE_PATH="$HOME/.local/chrome/opt/google/chrome/chrome"

# Userspace binaries (yt-dlp, ffmpeg, etc.)
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
