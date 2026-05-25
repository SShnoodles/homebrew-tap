class Pulse < Formula
  desc "Modern IoT TUI monitor"
  homepage "https://github.com/SShnoodles/Pulse-TUI"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.4/pulse-aarch64-apple-darwin.tar.xz"
      sha256 "7450b6001e8e59af0dcf72545a44eb877fd004111f00fa77402e0c143569359f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.4/pulse-x86_64-apple-darwin.tar.xz"
      sha256 "d6aa86f59ed8ef3cbf9cdc0fd51d16214a2df90d51900181bace84eb1f88ef49"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.4/pulse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e7f7ae0cef6aaffb1432b85ab03e56b714c59d1cbd672b9808477d6f8055b68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.4/pulse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2051124f51429a93ede23108aede327e4f8781d7ad86f531b4d2703c1cf00344"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "pulse" if OS.mac? && Hardware::CPU.arm?
    bin.install "pulse" if OS.mac? && Hardware::CPU.intel?
    bin.install "pulse" if OS.linux? && Hardware::CPU.arm?
    bin.install "pulse" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
