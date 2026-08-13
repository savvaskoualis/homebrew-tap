cask "openfortitray" do
  version "0.1.25"
  sha256 "3e6e5f3fd4daa77d380700bebc45167afb31da89862f0518b0271b3693c7a094"

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
    Open OpenFortiTray, set your gateway in Settings, and Connect. On the first
    Connect the app asks for your Mac administrator password once, to install a
    small root-owned helper (an openconnect wrapper and a scoped sudoers rule)
    that brings the tunnel up. No separate install step is needed.

    If you prefer to install that helper ahead of time, or the first-run prompt
    fails, you can run it manually:

      curl -fsSL https://raw.githubusercontent.com/savvaskoualis/openfortitray/v#{version}/scripts/install-helper.sh | sudo bash

    Quit FortiClient and disable it at login before connecting — FortiGate
    allows only one SSL-VPN session per user.
  EOS

  zap trash: [
    "~/Library/Application Support/openfortitray",
    "~/Library/LaunchAgents/io.github.savvaskoualis.openfortitray.plist",
  ]
end
