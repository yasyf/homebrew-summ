Language::Python::Virtualenv::Virtualenv.prepend(Module.new do
  def pip_install_with_deps_and_link(buildpath)
    pip_install(buildpath) # install with all deps
    do_pip "uninstall", "-y", buildpath.stem.split("-").first # uninstall root package
    pip_install_and_link buildpath # install and link root package
  end

  private

  def do_pip(*args)
    @formula.system @venv_root/"bin/pip", *args
  end

  def do_install(targets)
    targets = Array(targets)
    do_pip "install", "-v", "--ignore-installed", *targets
  end
end)

class SummLib < Formula
  include Language::Python::Virtualenv

  desc "Summ Python Library"
  homepage "https://github.com/yasyf/summ"
  url "https://files.pythonhosted.org/packages/65/a7/36df300c4b1c6a783903b3748cf21de8ce5df5e546b786c3221d58b65dae/summ-0.1.14.tar.gz"
  sha256 "ab880b79882c40defe39261efac643e50dd8bec218e3640153450067ef869e2b"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/yasyf/homebrew-summ/releases/download/summ-lib-0.1.13"
    sha256                               arm64_ventura: "9f0168290ac88d82b3d255cf7cc7111f4ea8f23afc60e376dc677cf6e152f1e0"
    sha256 cellar: :any,                 monterey:      "fa1ff636a7b4db32853807bae441e804a18a7dc2ba41ac7792af33edc422ad04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddcdf8aecae9d60a97c8e8e34e96bdae2d3ae75a9336a57c56f430f0388d5cb5"
  end

  depends_on "python@3.11"

  if OS.linux?
    require "extend/os/linkage_checker"
    LinkageChecker::SYSTEM_LIBRARY_ALLOWLIST += ["libz.so.1"]
    allowed_missing_libraries.merge([/libgfortran/, /libquadmath/])
  end

  def install
    ENV["BLAS"] = ENV["LAPACK"] = ENV["ATLAS"] = "None"

    venv = virtualenv_create(libexec, "python3.11")
    root = venv.instance_variable_get(:@venv_root)
    system "python3.11", "-m", "venv", "--upgrade", "--upgrade-deps", root
    system root/"bin"/"pip", "install", "-U", "wheel", "packaging", "pip"
    venv.pip_install_with_deps_and_link buildpath

    pth = prefix/Language::Python.site_packages("python3.11")/"summ.pth"
    pth.write libexec/"lib/python3.11/site-packages"
  end

  test do
    shell_output("#{libexec/"bin"/"python"} -c 'import summ'")
  end
end
