defmodule Imagery.AI do
  @moduledoc false

  alias OpenaiEx.Images
  require Logger

  def generate_image(prompt) do
    Logger.info("Generating Image: #{prompt}")

    token = Application.fetch_env!(:imagery, :openai_key)
    openai = OpenaiEx.new(token)
    img_req = Images.Generate.new(prompt: prompt, size: "256x256", n: 1)

    {:ok, %{"data" => [%{"url" => url}]}} =
      openai
      |> Images.generate(img_req)

    {:ok, url}
  end
end
