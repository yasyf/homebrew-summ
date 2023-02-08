class SummLib < Formula
  include Language::Python::Virtualenv

  desc "Summ Python Library"
  homepage "https://github.com/yasyf/summ"
  url "https://files.pythonhosted.org/packages/30/60/918eeab444c441ac4064bb60b3681d93a102c2ef4b3c3804803f2e9744de/summ-0.1.7.tar.gz"
  sha256 "c27c5fce3526726fc3d52ad8c65850b100dc6895bea23d856e9d0e2f4590dc6a"
  license "AGPL-3.0-only"

  depends_on "python@3.11"

  def install
    ENV["BLAS"] = ENV["LAPACK"] = ENV["ATLAS"] = "None"

    venv = virtualenv_create(libexec, "python3.11")
    root = venv.instance_variable_get(:@venv_root)
    system "python3.11", "-m", "venv", "--upgrade", "--upgrade-deps", root
    system root/"bin"/"pip", "install", "-U", "wheel", "packaging", "pip"
    venv.pip_install_and_link buildpath
  end

  test do
    shell_output("python -c 'import summ'")
  end
end
