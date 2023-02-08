class Summ < Formula
  include Language::Python::Virtualenv

  desc "GPT-based Conversation Summarizer"
  homepage "https://github.com/yasyf/summ"
  url "https://files.pythonhosted.org/packages/1c/3c/0a5715b108c0177863bf6138d08c3ea190cc54a39cffe63f12ae89a476b7/summ-0.1.4.tar.gz"
  sha256 "e685ec64920cac7f2bf61689bfbf1fcbcb1ac5d9b57421a06daf66d789d4585e"
  license "AGPL-3.0-only"

  depends_on "python@3.11"
  depends_on "yasyf/summ/redis-stack"

  def install
    ENV["BLAS"] = ENV["LAPACK"] = ENV["ATLAS"] = "None"

    venv = virtualenv_create(libexec, "python3.11")
    root = venv.instance_variable_get(:@venv_root)
    system "python3.11", "-m", "venv", "--upgrade", "--upgrade-deps", root
    system root/"bin"/"pip", "install", "-U", "wheel", "packaging", "pip"
    venv.pip_install_and_link buildpath
  end

  test do
    shell_output("#{bin}/summ --help")
  end
end
