# Homebrew cask for TailConnect. Lives in the tap repo
# github.com/imbikramsaha/homebrew-tap as Casks/tailconnect.rb, so users run:
#   brew tap imbikramsaha/tap && brew trust imbikramsaha/tap
#   brew install --cask tailconnect
# scripts/update-cask.sh fills in version and sha256 for a release.
cask "tailconnect" do
  version "0.3.1"
  sha256 "e72d7a1ed6eacd0e9cf0220e5d7b70da4e1290183669e2c9a802a6eb7ac6c79f"

  url "https://github.com/imbikramsaha/TailConnect/releases/download/v#{version}/TailConnect-#{version}-macos.dmg"
  name "TailConnect"
  desc "Connect to all your computers over Tailscale: terminals, editors, ports, monitoring"
  homepage "https://github.com/imbikramsaha/TailConnect"

  livecheck do
    url :url
    strategy :github_latest
  end

  # TailConnect updates itself from GitHub Releases.
  auto_updates true
  depends_on macos: :ventura

  app "TailConnect.app"
  binary "#{appdir}/TailConnect.app/Contents/MacOS/tailconnect"

  # Remove paired devices' keys from ~/.ssh/authorized_keys and the
  # ~/.ssh/config Include before the app goes away.
  uninstall quit:   "io.github.imbikramsaha.tailconnect",
            script: {
              executable:   "#{appdir}/TailConnect.app/Contents/MacOS/tailconnect",
              args:         ["cleanup"],
              must_succeed: false,
            }

  zap trash: [
    "~/Library/Application Support/TailConnect",
    "~/Library/LaunchAgents/com.tailconnect.app.plist",
    "~/.ssh/tailconnect",
  ]
end
