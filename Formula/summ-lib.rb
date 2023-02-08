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
  url "https://files.pythonhosted.org/packages/c1/94/c1ed8b953776c8991c2151fe52d0b2568166fc05d13eea03705a3004d632/summ-0.1.11.tar.gz"
  sha256 "52bbfe31e81aaed996e31157be4bffc05974141f004feed8dbc65691edd3f5a4"
  license "AGPL-3.0-only"

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
