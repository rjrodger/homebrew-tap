class Aless < Formula
  desc "Terminal viewer and JSON CLI for JSON, YAML, TOML, CSV, XML and more"
  homepage "https://aless.tabnas.dev"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.4.4/aless-aarch64-apple-darwin.tar.xz"
      sha256 "97e6fe71957b7bf946d08cd1510ec92414f1aa8cde507d1dda20a878963c7176"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.4.4/aless-x86_64-apple-darwin.tar.xz"
      sha256 "80ba7d7582bb4909a890fba7cdb3c5c5fc7986d7bddd73fa4653b1d808339d8e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.4.4/aless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ccf04c5102573ce7f9f94fb4ef3425f551a4638c4857745b0627fc73455f3c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.4.4/aless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "72470976ecc51f95e8745eff4f17077f12f5b8e52525d4906407f5db0b8a3bf5"
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
    assert_equal '{"a":[1,2]}', pipe_output("#{bin}/aless --json --compact", '{"a": [1, 2]}').strip
  end
end
