{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.chromium = {
    enable = true;
    extensions = [
      # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      # "fnaicdffflnofjppbagibeoednhnbjhg" # floccus-bookmarks-sync
      # "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      # "jinjaccalgkegednnccohejagnlnfdag" # violentmonkey
      # "bpoadfkcbjbfhfodiogcnhhhpibjhbnh" # 沉浸式翻译
      # "djflhoibgkdhkhhcedjiklpkjnoahfmg" # user-agent-switcher
      # "mpiodijhokgodhhofbcjdecpffjipkle" # singlefile
      # "jpbjcnkcffbooppibceonlgknpkniiff" # global-speed
    ];
    extraOpts = {
      AdvancedProtectionAllowed = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BookmarkBarEnabled = true;
      ClearBrowsingDataOnExitList = [
        "browsing_history"
        "download_history"
        "cached_images_and_files"
      ];
      EncryptedClientHelloEnabled = true;
      HighEfficiencyModeEnabled = false;
      MetricsReportingEnabled = false;
      SideSearchEnabled = false;
      SpellCheckServiceEnabled = false;
      SpellcheckEnabled = false;
      TranslateEnabled = true;
      PasswordManagerEnabled = false;
      CloudPrintProxyEnabled = false;
      ShowHomeButton = true;
    };
  };
}
