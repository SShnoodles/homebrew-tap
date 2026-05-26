class Pulse < Formula
  desc "Modern IoT TUI monitor"
  homepage "https://github.com/SShnoodles/Pulse-TUI"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.2.1/pulse-aarch64-apple-darwin.tar.xz"
      sha256 "44586fa3bee7a58a6f370c4181c88c9eedd547ef7c7983d8b8dbd9ad3f8d217b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.2.1/pulse-x86_64-apple-darwin.tar.xz"
      sha256 "4cc76b9bd7f17a461661b45d30ba8bec39fd433e07e7eeaf3fe81970f7993627"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.2.1/pulse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "272c2d465879c96facd8109015a002c3df2d5dae3d1b4cffeb8cdc2cd98f3ce1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.2.1/pulse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b3d6bc6f27862b38f3a070b563e837c7b3fcfecf44d5ed39e9474e8195974c70"
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
