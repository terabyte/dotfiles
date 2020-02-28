# BEGIN env Setup -- Managed by Ansible DO NOT EDIT.

# Single-brace syntax because this is required in bash, dash, zsh, etc
if [ -e "$HOME/env/etc/indeed_profile" ]; then
    . "$HOME/env/etc/indeed_profile"
fi

# Add ~/env/bin to your PATH to use the shared shell scripts from delivery/env
if [ -d "$HOME/env/bin" ]; then
    PATH="$HOME/env/bin:$PATH"
fi

# END env Setup -- Managed by Ansible DO NOT EDIT.

export CMYERS_PROFILE_LOADED="yes"
