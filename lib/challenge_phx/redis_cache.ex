defmodule ChallengePhx.RedisCache do
  alias ChallengePhx.Products
  import Logger
  def boot() do
    Logger.info("Boot App Cache")
    Products.boot_cache
  end

end