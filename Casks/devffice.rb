cask "devffice" do
  version "0.4.2"
  sha256 "ff04dc698ee886d9b43e33a877eaeba48638b1491e0803d765071bb67a7539a7"

  # One universal build: Apple Silicon and Intel.
  url "https://devffice.com/download/devffice-#{version}-mac.zip"
  name "devffice"
  desc "Connects your Mac to devffice: terminals, editor and Claude from any browser"
  homepage "https://devffice.com/"

  depends_on macos: ">= :monterey"
  # The daemon the app carries runs on Homebrew's node (22 or newer), by its stable opt path.
  depends_on formula: "node"

  app "devffice.app"

  # Homebrew quarantines what it downloads. This build carries only an ad-hoc signature, so a
  # quarantined copy is stopped by Gatekeeper with a dialog whose single button is "Done".
  # Removing the flag is what makes `brew install` open on the first click — trusting this tap the
  # way you already trust the app it installs. Delete it the day the app is notarized.
  #
  # Then the app opens by itself (architecture 2026-10-26 §0): its window offers Connect to
  # devffice, and on first start it installs the daemon's launch agent (replacing the one the
  # older Electron app wrote).
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/devffice.app"]
    system_command "/usr/bin/open", args: ["#{appdir}/devffice.app"]
  end

  uninstall quit:      "dev.devffice.app",
            launchctl: "sk.kubanda.devffice"

  # Both live in the user's own home, so they are trashed rather than deleted (Homebrew runs every
  # `delete:` through sudo). Kept on uninstall, removed by `brew zap`. ~/.devffice holds the
  # machine identity, its keys and the daemon log.
  zap trash: [
    "~/.devffice",
    "~/Library/LaunchAgents/sk.kubanda.devffice.plist",
  ]
end
