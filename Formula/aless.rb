class Aless < Formula
  desc "Terminal viewer for JSON, YAML, TOML, CSV, XML and more, as one tree"
  homepage "https://aless.tabnas.dev"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.8.0/aless-aarch64-apple-darwin.tar.xz"
      sha256 "b9dc1ada69d116898b9e88b7e14860e0d3e2f61e2986132088b02d2887690dd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.8.0/aless-x86_64-apple-darwin.tar.xz"
      sha256 "b221a421c337c8f296effb76804b02cdee990572c1f751919d279495eccabf91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.8.0/aless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ab7798328ad066698770c1c9724d329c48a2c30d4dda3ce5c752387e5872dba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.8.0/aless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a014d665376bbd22918852b10072d4f359bf85c75f1310bf9c68775427b4c5bd"
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
