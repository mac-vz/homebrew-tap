class Macvz < Formula
  desc "macOS Virtualization"
  homepage "https://github.com/mac-vz/macvz"
  url "https://github.com/mac-vz/macvz/archive/v0.0.4-1.tar.gz"
  sha256 "58e0a48624554e39230b3dd12eb61b8eb897f2d8d222b3b6abf349d0605d611d"
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