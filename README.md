# kubandam/homebrew-tap

Homebrew tap for [workshop](https://workshop-relay.m-kubanda1.workers.dev/) — your Mac's terminal and
editor, in any browser.

```sh
brew install kubandam/tap/workshop
```

Apple Silicon only. The app lands in `/Applications` and appears in the menu bar; open it and sign in
with GitHub.

## Why a tap and not homebrew-cask

The app is signed ad-hoc, not with an Apple Developer ID. Homebrew quarantines everything it
downloads, and a quarantined ad-hoc build is stopped by Gatekeeper with a dialog offering only
"Done" — the way out is buried in System Settings > Privacy & Security > Open Anyway.

So the cask removes the quarantine flag after installing. That is a deliberate trade, spelled out in
[`Casks/workshop.rb`](Casks/workshop.rb): installing from this tap means trusting the tap the way you
already trust the app. homebrew-cask would rightly refuse it, which is why this lives here.

Once the app is signed with a Developer ID and notarized, that stanza goes away and this becomes an
ordinary cask.

## Releasing

`scripts/publish-release.mjs` in the workshop repo uploads the DMG and prints the `version` and
`sha256` lines to paste into the cask.

## Uninstalling

```sh
brew uninstall --cask workshop      # removes the app
brew zap --cask workshop            # also removes ~/.workshop (keys, pairings, log)
```
