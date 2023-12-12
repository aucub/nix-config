{
  pkgs,
  config,
  lib,
  ...
}: {
  i18n.inputMethod.fcitx5.settings = {
    inputMethod = {
      "GroupOrder" = {"0" = "Default";};
      "Groups/0" = {
        "Default Layout" = "us";
        "DefaultIM" = "pinyin";
        "Name" = "Default";
      };
      "Groups/0/Items/0" = {"Name" = "keyboard-us";};
      "Groups/0/Items/1" = {"Name" = "pinyin";};
    };
    globalOptions = {
      "Hotkey"."EnumerateWithTriggerKeys" = "True";
      "Hotkey"."EnumerateSkipFirst" = "False";
      "Hotkey/TriggerKeys"."0" = "Zenkaku_Hankaku";
      "Hotkey/TriggerKeys"."1" = "Hangul";
      "Hotkey/TriggerKeys"."2" = "Shift+Shift_L";
      "Hotkey/TriggerKeys"."3" = "Shift+Shift_R";
      "Hotkey/EnumerateGroupForwardKeys"."0" = "Super+space";
      "Hotkey/EnumerateGroupBackwardKeys"."0" = "Shift+Super+space";
      "Hotkey/ActivateKeys"."0" = "Hangul_Hanja";
      "Hotkey/DeactivateKeys"."0" = "Hangul_Romaja";
      "Hotkey/PrevPage"."0" = "Up";
      "Hotkey/PrevPage"."1" = "Page_Up";
      "Hotkey/NextPage"."0" = "Down";
      "Hotkey/NextPage"."1" = "Next";
      "Hotkey/PrevCandidate"."0" = "Shift+Tab";
      "Hotkey/NextCandidate"."0" = "Tab";
      "Hotkey/TogglePreedit"."0" = "Control+Alt+P";
      "Behavior"."ActiveByDefault" = "False";
      "Behavior"."ShareInputState" = "Program";
      "Behavior"."PreeditEnabledByDefault" = "True";
      "Behavior"."ShowInputMethodInformation" = "True";
      "Behavior"."showInputMethodInformationWhenFocusIn" = "True";
      "Behavior"."ShowFirstInputMethodInformation" = "True";
      "Behavior"."DefaultPageSize" = "9";
      "Behavior"."OverrideXkbOption" = "False";
      "Behavior"."PreloadInputMethod" = "True";
      "Behavior"."AllowInputMethodForPassword" = "True";
      "Behavior"."ShowPreeditForPassword" = "False";
      "Behavior"."AutoSavePeriod" = "99999";
    };
    addons = {
      classicui = {
        VerticalCandidateList = false;
        WheelForPaging = true;
        Font = "更纱黑体 UI SC 14";
        MenuFont = "更纱黑体 UI SC 14";
        TrayFont = "更纱黑体 UI SC 14";
        TrayOutlineColor = "#000000";
        TrayTextColor = "#ffffff";
        PreferTextIcon = false;
        ShowLayoutNameInIcon = true;
        UseInputMethodLanguageToDisplayText = true;
        Theme = "default";
        DarkTheme = "default-dark";
        UseDarkTheme = true;
        UseAccentColor = true;
        PerScreenDPI = false;
        ForceWaylandDPI = 0;
        EnableFractionalScale = true;
      };
      clipboard = {
        NumberOfEntries = 18;

        TriggerKey = {"0" = "Super+V";};
      };
      keyboard = {
        PageSize = 9;
        EnableEmoji = true;
        EnableQuickPhraseEmoji = true;
        ChooseModifier = "Alt";
        EnableHintByDefault = false;
        UseNewComposeBehavior = true;
        EnableLongPress = false;

        PrevCandidate = {"0" = "Shift+Tab";};

        NextCandidate = {"0" = "Tab";};

        HintTrigger = {"0" = "Control+Alt+H";};

        OneTimeHintTrigger = {"0" = "Control+Alt+J";};

        LongPressBlocklist = {"0" = "konsole";};
      };
      pinyin = {
        ShuangpinProfile = "Ziranma";
        ShowShuangpinMode = true;
        PageSize = 9;
        SpellEnabled = false;
        EmojiEnabled = true;
        ChaiziEnabled = true;
        ExtBEnabled = true;
        CloudPinyinEnabled = false;
        CloudPinyinIndex = 2;
        CloudPinyinAnimation = true;
        KeepCloudPinyinPlaceHolder = false;
        PreeditInApplication = true;
        PreeditCursorPositionAtBeginning = true;
        PinyinInPreedit = false;
        Prediction = false;
        PredictionSize = 10;
        SwitchInputMethodBehavior = "Commit current preedit";
        SecondCandidate = "";
        ThirdCandidate = "";
        UseKeypadAsSelection = false;
        BackSpaceToUnselect = true;
        NumberOfSentence = 2;
        LongWordLengthLimit = 4;
        QuickPhraseKey = "semicolon";
        VAsQuickphrase = false;
        FirstRun = false;

        ForgetWord = {"0" = "Control+7";};

        PrevPage = {
          "0" = "minus";
          "1" = "Up";
          "2" = "KP_Up";
          "3" = "Page_Up";
        };

        NextPage = {
          "0" = "equal";
          "1" = "Down";
          "2" = "KP_Down";
          "3" = "Next";
        };

        PrevCandidate = {"0" = "Shift+Tab";};

        NextCandidate = {"0" = "Tab";};

        ChooseCharFromPhrase = {
          "0" = "bracketleft";
          "1" = "bracketright";
        };

        FilterByStroke = {"0" = "grave";};

        QuickPhraseTrigger = {
          "0" = "www.";
          "1" = "ftp.";
          "2" = "http:";
          "3" = "mail.";
          "4" = "bbs.";
          "5" = "forum.";
          "6" = "https:";
          "7" = "ftp:";
          "8" = "telnet:";
          "9" = "mailto:";
        };

        Fuzzy = {
          VE_UE = true;
          NG_GN = true;
          Inner = true;
          InnerShort = true;
          PartialFinal = true;
          PartialSp = false;
          V_U = true;
          AN_ANG = true;
          EN_ENG = true;
          IAN_IANG = true;
          IN_ING = true;
          U_OU = true;
          UAN_UANG = true;
          C_CH = true;
          F_H = true;
          L_N = true;
          S_SH = true;
          Z_ZH = true;
        };
      };
      punctuation = {
        HalfWidthPuncAfterLetterOrNumber = true;
        TypePairedPunctuationsTogether = false;
        Enabled = true;

        Hotkey = {"0" = "Control+period";};
      };
      quickphrase = {
        ChooseModifier = "None";
        Spell = false;
        FallbackSpellLanguage = "en";

        TriggerKey = {
          "0" = "Super+grave";
          "1" = "Super+semicolon";
        };
      };
    };
  };
}
