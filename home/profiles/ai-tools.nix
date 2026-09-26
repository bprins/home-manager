{
  config,
  lib,
  pkgs,
  ...
}:
let
  # nixpkgs only builds the CLI; the gateway comes from the same workspace so
  # both stay on one version (the sandbox image tag is baked in at build time).
  # Pinned ahead of nixpkgs, which is still on 0.0.116. After a bump, run
  # ~/code/agent-sandbox/check.sh: its canary tracks a 0.1.1 /dev/tty bug.
  openshell = pkgs.openshell.overrideAttrs (
    finalAttrs: old: {
      version = "0.1.1";
      src = old.src.override {
        tag = "v${finalAttrs.version}";
        hash = "sha256-4dHxPxfuVru0TXFl6FG4Ork6iexUlthMqNNjFWRc81o=";
      };
      # overrideAttrs does not re-derive cargoDeps from cargoHash.
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-zQo6Z62V4n1vQU59fD2Rx3y0nMQuD2Q6A9lzsRyaswI=";
      };
      postPatch =
        builtins.replaceStrings
          [ ''members = ["crates/openshell-cli"]'' ]
          [
            ''members = ["crates/openshell-cli", "crates/openshell-gateway", "crates/openshell-driver-podman", "crates/openshell-prover-cli"]''
          ]
          old.postPatch;
    }
  );

  # ssh-config only varies by --name, so one wildcard block replaces running it
  # per sandbox and gives host aliases plain ssh can resolve.
  openshellProxy = pkgs.writeShellScript "openshell-ssh-proxy" ''
    name=''${1#openshell-}
    exec ${openshell}/bin/openshell ssh-proxy --gateway-name openshell \
      --name "''${name%.default}" --workspace default
  '';

  tlsDir = "${config.xdg.stateHome}/openshell/tls";
in
{
  programs.claude-code.enable = true;

  home.packages = [ openshell ];

  programs.ssh.settings."openshell-*.default" = {
    User = "sandbox";
    StrictHostKeyChecking = "no";
    UserKnownHostsFile = "/dev/null";
    GlobalKnownHostsFile = "/dev/null";
    LogLevel = "ERROR";
    ServerAliveInterval = 15;
    ServerAliveCountMax = 3;
    ProxyCommand = "${openshellProxy} %n";
  };

  # Idempotent: keeps existing PKI and only fills in what is missing.
  home.activation.openshellCerts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${openshell}/bin/openshell-gateway generate-certs \
      --output-dir ${lib.escapeShellArg tlsDir} \
      --server-san host.openshell.internal
  '';

  launchd.agents.openshell-gateway = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [ "${openshell}/bin/openshell-gateway" ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/openshell-gateway.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/openshell-gateway.log";
    };
  };

  # osh <sandbox> [command...]: SSH into an OpenShell sandbox
  programs.zsh.initContent = ''
    osh() { ssh -t "openshell-$1.default" "''${@:2}"; }
  '';
}
