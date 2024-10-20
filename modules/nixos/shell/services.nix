{
  flake,
  pkgs,
  config,
  ...
}:
let
  defaultUserName = flake.config.hosts."${config.networking.hostName}".defaultUserName;
  defaultUserUid = flake.config.users."${defaultUserName}".uid;
in
{
  services = {
    acpid.enable = true;
    upower = {
      enable = true;
      noPollBatteries = true;
    };
    power-profiles-daemon.enable = false;
    tlp.enable = false;
    fstrim.enable = if config.fileSystems."/".fsType == "bcachefs" then false else true;
    btrfs.autoScrub.enable = if config.fileSystems."/".fsType == "btrfs" then true else false;
    dbus.implementation = "broker";
    avahi.enable = false;
    geoclue2.enable = false;
    journald.extraConfig = ''
      ForwardToConsole=no
      ForwardToKMsg=no
      ForwardToSyslog=no
      ForwardToWall=no
      SystemMaxFileSize=10M
      SystemMaxUse=100M
    '';
    psd.enable = true;
    resolved = {
      enable = true;
      dnsovertls = "true";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "2400:3200::1"
        "2606:4700:4700::1001"
      ];
    };
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    kmscon = {
      enable = true;
      fonts = [
        {
          name = "Sarasa Mono SC";
          package = pkgs.sarasa-gothic;
        }
      ];
      extraConfig = "font-size=20";
      hwRender = true;
    };
    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
    };
    libinput = {
      enable = true;
      mouse.accelProfile = "adaptive";
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        accelProfile = "adaptive";
        disableWhileTyping = true;
      };
    };
    displayManager.autoLogin = {
      enable = true;
      user = defaultUserName;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      desktopManager.xterm.enable = false;
      excludePackages = with pkgs; [ xterm ];
      wacom.enable = false;
    };
    # flatpak.enable = true;
  };

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=25s";
    sleep.extraConfig = "AllowHibernation=no";
    timers.suspend-then-shutdown = {
      wantedBy = [ "sleep.target" ];
      partOf = [ "sleep.target" ];
      onSuccess = [ "suspend-then-shutdown.service" ];
      timerConfig = {
        OnActiveSec = "2h";
        AccuracySec = "30m";
        RemainAfterElapse = false;
        WakeSystem = true;
      };
    };
    services = {
      suspend-then-shutdown = {
        description = "Shutdown after suspend";
        path = with pkgs; [ dbus ];
        environment = {
          DISPLAY = ":0";
          DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${toString defaultUserUid}/bus";
          XDG_RUNTIME_DIR = "/run/user/${toString defaultUserUid}";
        };
        script = ''
          sleep 1m
          current_timestamp=$(${pkgs.coreutils}/bin/date +%s)
          active_enter_timestamp=$(${pkgs.coreutils}/bin/date -d "$(systemctl show -p ActiveEnterTimestamp sleep.target | cut -d= -f2)" +%s)
          if [ $((current_timestamp - active_enter_timestamp)) -ge 6000 ]; then
            ${pkgs.gnome-session}/bin/gnome-session-quit --power-off
          fi
        '';
        serviceConfig = {
          Type = "simple";
          User = defaultUserUid;
        };
      };
      systemd-gpt-auto-generator.enable = false;
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
      alsa-store.enable = false;
      keyboard-brightness = {
        description = "Set keyboard brightness after resume";
        wantedBy = [
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          WorkingDirectory = "/sys/class/leds/platform::kbd_backlight/";
          ExecStart = "${pkgs.bash}/bin/sh -c \"cat brightness >> /var/tmp/kbd_brightness_current && echo 0 > brightness\"";
          ExecStop = "${pkgs.bash}/bin/sh -c 'sleep 3s && cat /var/tmp/kbd_brightness_current > brightness && rm /var/tmp/kbd_brightness_current'";
        };
      };
      numlock-brightness = {
        description = "Set numlock Brightness";
        after = [
          "graphical.target"
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
        wantedBy = [
          "graphical.target"
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "/sys/class/leds/";
          ExecStart = "${pkgs.bash}/bin/sh -c 'sleep 3s && for dir in ./*::numlock*/; do [ -d \"$dir\" ] && echo 0 > \"$dir/brightness\"; done'";
          User = "root";
        };
      };
    };
  };
}
