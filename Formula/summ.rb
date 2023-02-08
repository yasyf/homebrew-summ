class Summ < Formula
  include Language::Python::Virtualenv

  desc "GPT-based Conversation Summarizer"
  homepage "https://summ.rtfd.io"
  url "https://github.com/yasyf/summ/archive/refs/tags/0.1.12.tar.gz"
  sha256 "96f7649fac57897c007fdb626d20d674afba9c6f7747a5b7ab0200a5db338ab4"
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
