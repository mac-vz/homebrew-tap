class Macvz < Formula
  desc "macOS Virtualization"
  homepage "https://github.com/mac-vz/macvz"
  url "https://github.com/mac-vz/macvz/archive/v0.0.2.tar.gz"
  sha256 "b147c4ef0f0ae5348232fdfe35594642551f23161e503b9a85d6c3fe9a972ce4"
  license "MIT"
  head "https://github.com/mac-vz/macvz.git", branch: "main"

  depends_on "go" => :build
  depends_on macos: :monterey
  depends_on :macos

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"
    system "codesign", "--entitlements", "vz.entitlements", "-s", "-", "_output/bin/macvz"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/macvz", "completion", "bash")
    (bash_completion / "macvz").write output
    output = Utils.safe_popen_read("#{bin}/macvz", "completion", "zsh")
    (zsh_completion / "_macvz").write output
    output = Utils.safe_popen_read("#{bin}/macvz", "completion", "fish")
    (fish_completion / "macvz.fish").write output
  end
end