class Summ < Formula
  include Language::Python::Virtualenv

  desc "GPT-based Conversation Summarizer"
  homepage "https://summ.rtfd.io"
  url "https://github.com/yasyf/summ/archive/refs/tags/0.1.13.tar.gz"
  sha256 "2fc76f24985b6d9ca00732a647349ea97b69cc316f892d9a19abce1eb2bf759e"
  license "AGPL-3.0-only"

  depends_on "yasyf/summ/redis-stack"
  depends_on "yasyf/summ/summ-lib"

  def install
    prefix.install "docs"
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-1234567890"
    shell_output("#{Formula["summ-lib"].bin}/summ-example --help")
  end
end
