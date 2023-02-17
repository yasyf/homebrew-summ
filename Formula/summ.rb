class Summ < Formula
  include Language::Python::Virtualenv

  desc "GPT-based Conversation Summarizer"
  homepage "https://summ.rtfd.io"
  url "https://github.com/yasyf/summ/archive/refs/tags/0.1.14.tar.gz"
  sha256 "5679c52b92a4e542dd2050a184a41e02db82d0e6628fdd1857b615d6d1c560b9"
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
