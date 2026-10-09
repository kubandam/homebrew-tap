cask "devffice" do
  version "0.3.7"
  sha256 "518131c88b2c4c5456bbaaf852e64980f5547fa09e4aa85c337eb5b26b250e36"

  url "https://devffice.com/download/devffice-#{version}-arm64.dmg"
  name "devffice"
  desc "Your Mac's terminal and editor, in any browser"
  homepage "https://devffice.com/"

  # Only an Apple Silicon DMG is published. Without this an Intel Mac installs a bundle it cannot
  # run and finds out at launch; brew should say so first.
  depends_on arch: :arm64

  app "devffice.app"

  # Homebrew quarantines what it downloads (Cask::Quarantine.cask! on the download, and the flag is
  # copied onto the app when it is moved into place). This build carries only an ad-hoc signature,
  # so a quarantined copy is stopped by Gatekeeper with a dialog whose single button is "Done" —
  # the way out is System Settings > Privacy & Security > Open Anyway, which is where most people
  # give up. Removing the flag here is what makes `brew install` open on the first click.
  #
  # This is a deliberate trade: installing from this tap means trusting it the way you already
  # trust the app it installs. It is also why this cask belongs in a personal tap and would never
  # be accepted into homebrew-cask.
  #
  # Delete this stanza the day the app is signed with a Developer ID and notarized.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/devffice.app"]
  end

  uninstall quit:      "dev.devffice.app",
            launchctl: "sk.kubanda.devffice"

  # Both live in the user's own home, so they are trashed rather than deleted: Homebrew runs every
  # `delete:` through sudo, and an uninstall that stops to ask for a password is worse than one that
  # leaves a plist behind. Kept on uninstall, removed by `brew zap`.
  #
  # ~/.devffice holds the machine identity, pairing keys and the daemon log.
  zap trash: [
    "~/.devffice",
    "~/Library/LaunchAgents/sk.kubanda.devffice.plist",
  ]
end
