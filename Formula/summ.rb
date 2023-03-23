class Summ < Formula
  include Language::Python::Virtualenv

  desc "GPT-based Conversation Summarizer"
  homepage "https://summ.rtfd.io"
  url "https://github.com/yasyf/summ/archive/refs/tags/0.1.17.tar.gz"
  sha256 "7a816f810a43140a8cf4615e3da8d9a2ac0895b77096aa49dede2bcaf178a9f9"
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
