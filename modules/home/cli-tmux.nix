{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.home.cli.tmux;
in
{
  options.gorschu.home.cli.tmux = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure tmux";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.smug = {
      enable = true;
    };
    programs.tmux = {
      enable = true;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      sensibleOnTop = true;
      terminal = "tmux-256color";
      extraConfig = ''
                        # set window titles
                        set-option -g set-titles on
                        # host:session name.window index.pane index • name of window • title of pane
                        set-option -g set-titles-string '#h:#S.#I.#P • #W • #T'

                	# keep unattached sessions alive
                        set-option -g destroy-unattached off

                        # monitor for activity
                        set-window-option -g monitor-activity on
                        set-option -gw window-status-activity-style fg=default,bg=default
                        # monitor for any bell and only do it visually
                        set-option -g bell-action any
                        set-option -g visual-bell on

                        # automatically rename windows
                        setw -g automatic-rename on
                        set -g allow-rename on

                        # update the these variables of terminal emulator when creating a new session or attaching a existing session
                        set -g update-environment 'DISPLAY SSH_AUTH_SOCK SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY TERM GPG_AGENT_INFO GPG_TTY'

                        # repeat a command for two seconds even without prefix key set
                        set -g repeat-time 2000

                        # make tmux copy (ctrl-b-[) start and end like vim's visual mode
                        # else it's space for start and enter for yank
                        # yank is handled by tmux-yank plugin
                        bind-key -Tcopy-mode-vi 'V' send -X rectangle-toggle
                        bind-key -Tcopy-mode-vi 'v' send -X begin-selection

                        # allow passthrough
                        set -g allow-passthrough on
                        # enable true color support for 256color terminals
                        set -ga terminal-overrides ',*256col*:Tc,xterm-kitty,wezterm,alacritty:Tc'
                        # nvim guicursor override
                        # :help tui-cursor-shape
                        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
                        # nvim tokyonight overrides - source: https://github.com/folke/tokyonight.nvim
                        # Undercurl
                        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
                        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

                        # bind prefix-C-c to send literal C-l to the terminal.
                        # C-l is taken by ... pretty much everything (including vim-tmux-navigator and
                        # tmux-pain-control) to move left, therefore clearing the screen is not
                        # possible in a normal way. Use prefix-C-c for that.
                        bind-key C-c send-keys 'C-l'
                        
                        # make pane swapping a bit like i3's super+H, super+L
                        bind-key -r M-H swap-pane -U
                        bind-key -r M-L swap-pane -D

        		# catppuccin - need to be loaded *after* plugin is loaded
                # Make the status line pretty and add some modules
                set -g status-right-length 100
                set -g status-left-length 100
                set -g status-left ""
                set -ag status-left "#{E:@catppuccin_status_host}"
                set -g status-right "#{E:@catppuccin_status_session}"
                set -ag status-right "#{E:@catppuccin_status_application}"
                set -ag status-right "#{E:@catppuccin_status_date_time}"
                set -ag status-right "#{E:@catppuccin_status_uptime}"
      '';
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.prefix-highlight;
          extraConfig = ''
            	  set -g @prefix_highlight_show_copy_mode 'on'
            	'';
        }
        {
          plugin = tmuxPlugins.sensible;
        }
        {
          plugin = tmuxPlugins.sessionist;
        }
        {
          plugin = tmuxPlugins.logging;
        }
        {
          plugin = tmuxPlugins.tmux-fzf;
        }
        {
          plugin = tmuxPlugins.resurrect;
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            	  set -g @continuum-restore 'off'
                      set -g @continuum-save-interval '15'
          '';
        }
        {
          plugin = tmuxPlugins.copycat;
        }
        {
          plugin = tmuxPlugins.pain-control;
        }
        {
          plugin = tmuxPlugins.yank;
        }
        {
          plugin = tmuxPlugins.tmux-fzf;
        }
        {
          plugin = tmuxPlugins.vim-tmux-navigator;
        }
        {
          plugin = tmuxPlugins.vim-tmux-focus-events;
        }
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
                    set -g @catppuccin_window_status_style "rounded"
            	set -g @catppuccin_flavor "${config.catppuccin.flavor}"
          '';
        }
      ];
    };
  };
}
