class Pulse < Formula
  desc "Modern IoT TUI monitor"
  homepage "https://github.com/SShnoodles/Pulse-TUI"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.3/pulse-aarch64-apple-darwin.tar.xz"
      sha256 "44042e478efe62c5820278ef170f853af5eb8f764dad73700fa017b11a1528a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.3/pulse-x86_64-apple-darwin.tar.xz"
      sha256 "e6c61d2eaf5eb6dccb055eb9604817c056370473401d74957ce5023e21678c57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.3/pulse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fd6ac65503953165b77bcf7ad5c0e7157d5c8ecc11789050b3d81b934f4b005a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.1.3/pulse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "99b1af813eac8c859797ca8d5ad25b97ea5528253b606ec08c2c9903c403cd22"
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
