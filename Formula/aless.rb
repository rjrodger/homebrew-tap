class Aless < Formula
  desc "Terminal viewer and JSON CLI for JSON, YAML, TOML, CSV, XML and more"
  homepage "https://aless.tabnas.dev"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.1.1/aless-aarch64-apple-darwin.tar.xz"
      sha256 "c72f3cfbc100cb9b1b56e6372ffcc99773ec0f07a42602ed981fdf8ee19c19d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.1.1/aless-x86_64-apple-darwin.tar.xz"
      sha256 "bf477690116afeda07e97d1c48ae8f43c02d8928845943e3cb8a6e7c7534d411"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rjrodger/aless/releases/download/v0.1.1/aless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "707db0fa70b2da9d021e5de99381c9cd2aed77e4487e5fddeb52146aaf98f2f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rjrodger/aless/releases/download/v0.1.1/aless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "04ebb5b8095e808aa8c414cccfe0dbac61b8c75a37fe9fe0b33e46de34865822"
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
