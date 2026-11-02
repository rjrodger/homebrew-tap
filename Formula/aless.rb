class Aless < Formula
  desc "Terminal viewer for JSON, YAML, TOML, CSV, XML and more, as one tree"
  homepage "https://aless.tabnas.dev"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.6.0/aless-aarch64-apple-darwin.tar.xz"
      sha256 "5175c771a9801372d046bf7de46d179b1aa0aab9b4e98211db865d4248ee09d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.6.0/aless-x86_64-apple-darwin.tar.xz"
      sha256 "e369a73b2f277f7bddea923b266aabc3a16b332b7930abeb1ba37ed9b9d32048"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.6.0/aless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5499a91f52786429f7a642e69e1b0c8c3b4c731e8ff8afd4b82ae9b803ef6ae2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.6.0/aless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d067b4a0cf5c5483dcbff8d8692bf83ee97f5016dce5ebdffa0f2703a4c0847"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "aless"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "aless"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aless"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aless"
    end

    install_binary_aliases!

    # The man page and the completions, where Homebrew's formulas put theirs.
    man1.install "man/aless.1"
    bash_completion.install "completions/aless.bash" => "aless"
    zsh_completion.install "completions/_aless"
    fish_completion.install "completions/aless.fish"
    pwsh_completion.install "completions/_aless.ps1"

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match "aless #{version}", shell_output("#{bin}/aless --version")
    assert_match ".SH SYNOPSIS", shell_output("#{bin}/aless --generate man")
    # A viewer: without a terminal it refuses to start, with status 2.
    assert_match "terminal", pipe_output("#{bin}/aless 2>&1", '{"a": [1, 2]}', 2)
  end
end
