class Macvz < Formula
  desc "macOS Virtualization"
  homepage "https://github.com/mac-vz/macvz"
  url "https://github.com/mac-vz/macvz/archive/v0.0.1.tar.gz"
  sha256 "d713ca9fb4fb65129723bb8514e2da87aa59d35b8a3b579f461baf7558afa9b7"
  license "MIT"
  head "https://github.com/mac-vz/macvz.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}", "clean", "binaries", "codesign"
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