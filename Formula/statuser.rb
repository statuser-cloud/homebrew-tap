class Statuser < Formula
  desc "Command-line client for the Statuser monitoring service"
  homepage "https://github.com/statuser-cloud/cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.1/statuser-macos-arm64.tar.gz"
      sha256 "42a989748f8bcef2279f08397a5ee26b8720ddf40f9a95f4911d1bd76ea36c6b"
    end
    on_intel do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.1/statuser-macos-x64.tar.gz"
      sha256 "907d8f2a3354ef702d64e93cd10cde339dcc9b097f116c42b97832d75794cf4c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.1/statuser-linux-arm64.tar.gz"
      sha256 "2e8aa4a94302ecd31ff421c2180357eac0bf6f334198e4f83b2fd1e845e9d201"
    end
    on_intel do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.1/statuser-linux-x64.tar.gz"
      sha256 "8ec40b16cbbf8f80003f8e6252225528d3864500d0bb0f977f23408d0aacb2a5"
    end
  end

  def install
    bin.install "statuser"
    generate_completions_from_executable(bin/"statuser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/statuser --version")
  end
end
