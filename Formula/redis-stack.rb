require "cask/caskroom"
require "cask_dependent"

CaskDependent::Requirement.class_eval do
  def freeze
    self
  end
end
CaskDependent::Requirement.fatal = true

DEPS = CaskDependent::Requirement.new([{ cask: "redis-stack/redis-stack/redis-stack-server" }]).freeze

class RedisStack < Formula
  desc "Service Support for redis-stack"
  homepage "https://redis.io/docs/stack/get-started/install/mac-os/"
  url "https://redismodules.s3.amazonaws.com/redis-stack/.donotremove", using: :nounzip
  version "latest"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  pour_bottle? do
    reason "No bottle available for this formula."
    false
  end

  keg_only "this formula is only used to install the service"

  on_macos do
    depends_on DEPS

    def server_path
      if (cask = Dir[Cask::Caskroom.path.join("redis-stack-server", "*")])
        Pathname.new(cask.last).join("bin", "redis-stack-server")
      else
        which("redis-stack-server")
      end
    end
  end

  on_linux do
    def server_path
      which("redis-stack-server")
    end
  end

  def install
    inreplace ".donotremove", "", ".donotremove"
    prefix.install ".donotremove" => "donotremove"
  end

  service do
    run server_path
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system "true"
  end
end
