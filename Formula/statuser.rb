class Statuser < Formula
  desc "Command-line client for the Statuser monitoring service"
  homepage "https://github.com/statuser-cloud/cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.0/statuser-macos-arm64.tar.gz"
      sha256 "97602431437697a7c0a611948e15110fd6e6d6363cc587fcbcdec783d333e8c4"
    end
    on_intel do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.0/statuser-macos-x64.tar.gz"
      sha256 "abff81dd0a24d420b582f1e7397c6ee14f501cf911cef5013ffc6b15653dcafb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.0/statuser-linux-arm64.tar.gz"
      sha256 "299c427e994363faa94259896e0465fa9a8724f95383a9155b1e46f84bd07221"
    end
    on_intel do
      url "https://github.com/statuser-cloud/cli/releases/download/v0.2.0/statuser-linux-x64.tar.gz"
      sha256 "1971dae02eba5a6b66251424e66fac87099ae3e0c8e5b188a0f08332afb5113e"
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
