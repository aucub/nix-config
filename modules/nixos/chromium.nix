{ options, ... }:
{
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
      # "gbkeegbaiigmenfmjfclcdgdpimamgkj" # Google文档
      # "ghbmnnjooekpmoecnnnilnnbdlolhkhi" # Google文档的离线功能
    ];
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSuggestURL = options.programs.chromium.defaultSearchProviderSuggestURL.example;
    defaultSearchProviderSearchURL = options.programs.chromium.defaultSearchProviderSearchURL.example;
    extraOpts = {
      # https://chromeenterprise.google/policies/
      AssistantWebEnabled = false;
      AdvancedProtectionAllowed = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BookmarkBarEnabled = false;
      BrowserLabsEnabled = false;
      BrowserNetworkTimeQueriesEnabled = false;
      BuiltInDnsClientEnabled = false;
      ClearBrowsingDataOnExitList = [
        "browsing_history"
        "download_history"
        "cached_images_and_files"
      ];
      ClickToCallEnabled = false;
      DefaultBrowserSettingEnabled = false;
      EncryptedClientHelloEnabled = true;
      ImportAutofillFormData = false;
      DnsOverHttpsMode = "automatic";
      ImportBookmarks = false;
      ImportHistory = false;
      ImportHomepage = false;
      ImportSavedPasswords = false;
      ImportSearchEngine = false;
      LensRegionSearchEnabled = false;
      MediaRecommendationsEnabled = false;
      MetricsReportingEnabled = false;
      PaymentMethodQueryEnabled = false;
      PromotionalTabsEnabled = false;
      SideSearchEnabled = false;
      SpellCheckServiceEnabled = false;
      SpellcheckEnabled = false;
      ShoppingListEnabled = false;
      TranslateEnabled = true;
      PasswordManagerEnabled = false;
      CloudPrintProxyEnabled = false;
      ShowHomeButton = true;
      CloudReportingEnabled = false;
      LogUploadEnabled = false;
      SafeBrowsingSurveysEnabled = false;
      DisableSafeBrowsingProceedAnyway = false;
      PrivacySandboxAdMeasurementEnabled = false;
      PrivacySandboxAdTopicsEnabled = false;
      PrivacySandboxPromptEnabled = false;
      PrivacySandboxSiteEnabledAdsEnabled = false;
      PasswordSharingEnabled = false;
      PasswordLeakDetectionEnabled = false;
      ZstdContentEncodingEnabled = true;
      HighEfficiencyModeEnabled = true;
      HardwareAccelerationModeEnabled = true;
      GoogleSearchSidePanelEnabled = false;
      FeedbackSurveysEnabled = false;
    };
    initialPrefs = {
      "autofill" = {
        "credit_card_enabled" = false;
        "profile_enabled" = false;
      };
      "bookmark_bar"."show_on_all_tabs" = false;
      "browser" = {
        "clear_data" = {
          "cookies" = false;
          "cookies_basic" = false;
          "time_period" = 4;
          "time_period_basic" = 4;
        };
        "enable_spellchecking" = false;
        "has_seen_welcome_page" = false;
        "last_clear_browsing_data_tab" = 1;
        "show_home_button" = true;
        "theme" = {
          "color_variant" = 1;
          "user_color" = -16711936;
        };
      };
      "credentials_enable_autosignin" = false;
      "credentials_enable_service" = false;
      "enable_do_not_track" = true;
      "https_only_mode_auto_enabled" = false;
      "https_only_mode_enabled" = true;
      "intl"."selected_languages" = "zh-CN,zh";
      "payments"."can_make_payment_enabled" = false;
      "privacy_guide"."viewed" = true;
      "privacy_sandbox"."first_party_sets_data_access_allowed_initialized" = true;
      "safebrowsing" = {
        "enabled" = true;
        "enhanced" = true;
        "esb_enabled_via_tailored_security" = false;
        "esb_opt_in_with_friendlier_settings" = true;
      };
      "search"."suggest_enabled" = false;
      "tracking_protection"."tracking_protection_3pcd_enabled" = false;
      "translate"."enabled" = false;
    };
  };
}
