defmodule ChallengePhx.RedisCache do
  alias ChallengePhx.Products
  require Logger
  
  def boot() do
    Logger.info("Boot App Cache")
    Products.boot_cache
  end

end