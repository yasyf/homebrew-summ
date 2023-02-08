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
  url "https://files.pythonhosted.org/packages/36/5c/6cc94e018ca07d9a31a340f6057939227cb9d3f29c315cab36798669ae90/summ-0.1.12.tar.gz"
  sha256 "6fe787cccc829fd7baef77a8558861587f262c537cce7d6c5160b45be08b9fa4"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/yasyf/homebrew-summ/releases/download/summ-lib-0.1.12"
    sha256 cellar: :any,                 monterey:     "b75c72f0a74ef48c6d23a9ca8748c22a12a5257a83c443bc4014d81a56f90b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "263b8fb36554e358ba1515b315debc9915f18fb99f92d94c86c7960b4da131d0"
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
