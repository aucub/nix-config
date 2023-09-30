{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.chromium = {
    enable = true;
    extraOpts = {
      # Miscellaneous
      AssistantWebEnabled = false;
      EnableMediaRouter = false;
      AccessibilityImageLabelsEnabled = false;
      AdsSettingForIntrusiveAdsSites = 2;
      AdvancedProtectionAllowed = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      AutoplayAllowed = false;
      BackgroundModeEnabled = false;
      BookmarkBarEnabled = true;
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
      EncryptedClientHelloEnabled = false;
      HighEfficiencyModeEnabled = false;
      ImportAutofillFormData = false;
      ImportBookmarks = false;
      ImportHistory = false;
      ImportHomepage = false;
      ImportSavedPasswords = false;
      ImportSearchEngine = false;
      InsecureFormsWarningsEnabled = true;
      LensRegionSearchEnabled = false;
      MediaRecommendationsEnabled = false;
      MetricsReportingEnabled = false;
      NetworkPredictionOptions = 2;
      PaymentMethodQueryEnabled = false;
      PromotionalTabsEnabled = false;
      SearchSuggestEnabled = true;
      ShoppingListEnabled = false;
      ShowFullUrlsInAddressBar = true;
      SideSearchEnabled = false;
      SitePerProcess = true;
      SpellCheckServiceEnabled = false;
      SpellcheckEnabled = false;
      TranslateEnabled = true;

      # Password manager
      PasswordManagerEnabled = false;

      # Printing
      CloudPrintProxyEnabled = false;

      # Startup, Home page and New Tab page
      HomepageLocation = "https://limestart.cn/";
      ShowHomeButton = true;
    };
  };
}