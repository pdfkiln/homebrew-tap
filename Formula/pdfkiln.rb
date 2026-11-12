class Pdfkiln < Formula
  desc "Drop-in replacement for wkhtmltopdf, powered by Chromium"
  homepage "https://pdfkiln.org"
  version "1.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pdfkiln/pdfkiln/releases/download/1.2.1/pdfkiln-1.2.1-macos-arm64.tar.gz"
      sha256 "17a9062142d725139b61a511ac74ebf05f50a73b657d4c635726675e627f1607"
    end
  end

  # Homebrew rewrites the ID of every dylib in a keg after install: those
  # of Chromium have no room for it, and would lose Google's signature.
  # Chromium goes in as a tar, unpacked by post_install, which runs after.
  def install
    system "tar", "-cf", "chromium.tar", "chromium"
    rm_r "chromium"
    libexec.install Dir["*"]
    %w[pdfkiln wkhtmltopdf wkhtmltoimage].each { |name| bin.install_symlink libexec/name }
  end

  def post_install
    tar = libexec/"chromium.tar"
    return unless tar.exist?

    rm_r libexec/"chromium" if (libexec/"chromium").exist?
    system "tar", "-xf", tar, "-C", libexec
    tar.delete
  end

  test do
    assert_match "wkhtmltopdf 0.12.6", shell_output("#{bin}/wkhtmltopdf --version")
    assert_match "wkhtmltoimage 0.12.6", shell_output("#{bin}/wkhtmltoimage --version")
  end
end
