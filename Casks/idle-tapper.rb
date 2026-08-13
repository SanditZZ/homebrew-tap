cask "idle-tapper" do
  version "0.1.2"
  sha256 "81482106b1943932012543a63dfc746ab371694ef2dbd5d9bc7bc56fa87ec89c"

  url "https://github.com/SanditZZ/idle-tapper-macos/releases/download/v#{version}/IdleTapper-#{version}.dmg"
  name "Idle Tapper"
  desc "Menu bar tap counter with a daily reset and a history of past days"
  homepage "https://github.com/SanditZZ/idle-tapper-macos"

  # The app updates itself daily via Sparkle once installed, so `brew upgrade`
  # should not fight it — this just keeps a fresh `brew install` current.
  auto_updates true

  depends_on macos: ">= :sonoma"

  app "IdleTapper.app"

  # Idle Tapper is ad-hoc signed, not notarized (no paid Apple Developer
  # account behind this project — see RELEASING.md upstream). Homebrew Cask
  # quarantines downloads like a browser would, which would otherwise leave
  # every installer facing the Gatekeeper prompt the project's README tells
  # manual downloaders to clear by hand. Clearing it here is what makes
  # `brew install --cask idle-tapper` actually install a working app.
  postflight do
    system_command "/usr/bin/xattr",
                    args: ["-dr", "com.apple.quarantine", "#{appdir}/IdleTapper.app"],
                    sudo: false
  end

  zap trash: [
    "~/Library/Application Support/IdleTapper",
    "~/Library/Preferences/com.kkpon3.IdleTapper.plist",
  ]
end
