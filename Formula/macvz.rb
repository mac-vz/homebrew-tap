class Macvz < Formula
  desc "macOS Virtualization"
  homepage "https://github.com/mac-vz/macvz"
  url "https://github.com/mac-vz/macvz/archive/v0.0.4.tar.gz"
  sha256 "54e4c658721816913de6d6e480e07395cb590c2d3f99bb3c5aa0121161cdcc56"
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