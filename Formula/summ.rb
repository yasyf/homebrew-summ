class Summ < Formula
  include Language::Python::Virtualenv

  desc "GPT-based Conversation Summarizer"
  homepage "https://summ.rtfd.io"
  url "https://github.com/yasyf/summ/archive/refs/tags/0.1.16.tar.gz"
  sha256 "092d115f3c3b5c812917aa18eb1f7cd5705bc076d4f76426d4e9690f56b3145d"
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
