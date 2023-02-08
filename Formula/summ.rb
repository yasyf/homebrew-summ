class Summ < Formula
  include Language::Python::Virtualenv

  desc "GPT-based Conversation Summarizer"
  homepage "https://summ.rtfd.io"
  url "https://raw.githubusercontent.com/yasyf/summ/0.1.7/README.md", using: :nounzip
  sha256 "c27c5fce3526726fc3d52ad8c65850b100dc6895bea23d856e9d0e2f4590dc6a"
  license "AGPL-3.0-only"

  depends_on "yasyf/summ/redis-stack"
  depends_on "yasyf/summ/summ-lib"

  def install
    prefix.install "objects.inv"
  end

  test do
    shell_output("#{bin}/summ-example --help")
  end
end
