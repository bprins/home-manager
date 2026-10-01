{
  config,
  lib,
  pkgs,
  ...
}:
let
  lock = Value: {
    inherit Value;
    Status = "locked";
  };
in
{
  options.programs.firefox.amoExtensions = lib.mkOption {
    type = with lib.types; attrsOf str;
    default = { };
    description = "addons.mozilla.org slug per extension ID, installed through policies.";
  };

  config = {
    # Policies instead of profiles: declaring a profile makes home-manager own profiles.ini
    programs.firefox = {
      enable = true;

      amoExtensions = {
        "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = "localcdn-fork-of-decentraleyes";
        "@unitedstatesenglishdictionary" = "us-english-dictionary";
        "firefox@ghostery.com" = "ghostery";
        "uBlock0@raymondhill.net" = "ublock-origin";
      };

      policies = {
        PasswordManagerEnabled = false;
        SanitizeOnShutdown = {
          FormData = true;
          Locked = true;
        };

        ExtensionSettings = lib.mapAttrs (_: slug: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
          installation_mode = "normal_installed";
        }) config.programs.firefox.amoExtensions;

        Preferences = lib.mapAttrs (_: lock) {
          "browser.ai.control.default" = "blocked";
          "browser.ml.chat.enabled" = false;
          "browser.ml.linkPreview.enabled" = false;
          "browser.tabs.groups.smart.enabled" = false;
          "extensions.ml.enabled" = false;
          "browser.translations.enable" = false;

          "browser.startup.homepage" = "about:blank";
          "browser.newtabpage.enabled" = false;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "sidebar.verticalTabs" = true;
          "intl.locale.requested" = "en-US,nl";

          "network.dns.disablePrefetch" = true;
          "network.prefetch-next" = false;
          "network.http.speculative-parallel-limit" = 0;

          "dom.disable_open_during_load" = false;
        };
      };
    };

    home.activation.setDefaultBrowser = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      lib.hm.dag.entryAfter [ "copyApps" ] ''
        run --quiet ${lib.getExe pkgs.defaultbrowser} firefox
      ''
    );

    xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      defaultApplications = lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_: "firefox.desktop");
    };
  };
}
