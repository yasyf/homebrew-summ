require "cask/caskroom"
require "cask_dependent"


class RedisStack < Formula
  desc "Redis Stack with Service Support"
  version "latest"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  url "https://redismodules.s3.amazonaws.com/redis-stack/.donotremove", using: :nounzip
  homepage "https://redis.io/docs/stack/get-started/install/mac-os/"
  keg_only "This formula is only used to install the redis-stack service."

  CaskDependent::Requirement.fatal true
  depends_on CaskDependent::Requirement.new([{ cask: "redis-stack/redis-stack/redis-stack-server" }])

  pour_bottle? do
    reason "No bottle available for this formula."
    false
  end

  def install
    inreplace ".donotremove", "", ".donotremove"
    prefix.install ".donotremove" => "donotremove"
  end

  service do
    run [Pathname.new(Dir[Cask::Caskroom.path.join("redis-stack-server", "*")].last).join("bin", "redis-stack-server")]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end
end
