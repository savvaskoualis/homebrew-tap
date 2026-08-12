cask "openfortitray" do
  version "0.1.4"
  sha256 "9df94e5443a9cceb4af35205590552773174a2af406c79b047cbf17be294a0a1"

  url "https://github.com/savvaskoualis/openfortitray/releases/download/v#{version}/OpenFortiTray-v#{version}.dmg",
      verified: "github.com/savvaskoualis/openfortitray/"
  name "OpenFortiTray"
  desc "Cross-platform FortiGate SSL-VPN menu-bar client (SAML/SSO)"
  homepage "https://github.com/savvaskoualis/openfortitray"

  depends_on formula: "openconnect"

  app "OpenFortiTray.app"

  # The app is ad-hoc signed but not notarized; strip the download quarantine so
  # Gatekeeper does not block first launch (no Apple Developer account needed).
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/OpenFortiTray.app"]
  end

  caveats <<~EOS
    OpenFortiTray installs the menu-bar app, but bringing the VPN tunnel up
    needs a one-time privileged helper (a root-owned openconnect wrapper and a
    scoped sudoers rule). Install it once with:

      curl -fsSL https://raw.githubusercontent.com/savvaskoualis/openfortitray/v#{version}/scripts/install-helper.sh | sudo bash

    Then open OpenFortiTray, set your gateway in Settings, and Connect.

    Quit FortiClient and disable it at login before connecting — FortiGate
    allows only one SSL-VPN session per user.
  EOS

  zap trash: [
    "~/Library/Application Support/openfortitray",
    "~/Library/LaunchAgents/io.github.savvaskoualis.openfortitray.plist",
  ]
end
