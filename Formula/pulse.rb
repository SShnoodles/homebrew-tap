class Pulse < Formula
  desc "Modern IoT TUI monitor"
  homepage "https://github.com/SShnoodles/Pulse-TUI"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.3.3/pulse-aarch64-apple-darwin.tar.xz"
      sha256 "dfb0f0716c87a67f8483ba351451d7a35b0adaadf8e6ecc84de047c0613a031d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.3.3/pulse-x86_64-apple-darwin.tar.xz"
      sha256 "044bb244bccee62bb12dfe18702a11dc25f94ff801198937184672ce9f775d9e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.3.3/pulse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f910dfe3311cb7d1cd47bda1b6477ccee9522292df9bf5b310a77f2976bbb2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SShnoodles/Pulse-TUI/releases/download/v0.3.3/pulse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74b060aad0d6552f27c762c1afe488d7656f4bceddc4ca4723fe88c1358afaff"
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
