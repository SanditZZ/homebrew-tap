cask "quotebar" do
  version "0.2.0"
  sha256 "8428c8eb6d3dfd8aa79e5e9558e5b01e2e2c79f8cf2c6551f4d0843baa24ac37"

  url "https://github.com/SanditZZ/quotebar-macos/releases/download/v#{version}/QuoteBar-#{version}.dmg"
  name "QuoteBar"
  desc "Menu bar app serving a random quote from on-device AI, live APIs or an offline set"
  homepage "https://github.com/SanditZZ/quotebar-macos"

  # The app updates itself daily via Sparkle once installed, so `brew upgrade`
  # should not fight it — this just keeps a fresh `brew install` current.
  auto_updates true

  depends_on macos: ">= :sonoma"

  app "QuoteBar.app"

  # QuoteBar is ad-hoc signed, not notarized (no paid Apple Developer account
  # behind this project — see RELEASING.md upstream). Homebrew Cask
  # quarantines downloads like a browser would, which would otherwise leave
  # every installer facing the Gatekeeper prompt the project's README tells
  # manual downloaders to clear by hand. Clearing it here is what makes
  # `brew install --cask quotebar` actually install a working app.
  postflight do
    system_command "/usr/bin/xattr",
                    args: ["-dr", "com.apple.quarantine", "#{appdir}/QuoteBar.app"],
                    sudo: false
  end

  # The container path is listed as well as the current one: builds before
  # 0.2.0 were sandboxed and kept the database inside the container, and the
  # first unsandboxed launch copies it out rather than moving it. A zap that
  # named only the new location would leave the original quote history behind.
  zap trash: [
    "~/Library/Application Support/QuoteBar",
    "~/Library/Containers/com.kkpon3.QuoteBar",
    "~/Library/Preferences/com.kkpon3.QuoteBar.plist",
  ]
end
