defmodule Imagery.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Imagery.Images` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        image_url: "some image_url",
        prompt: "some prompt"
      })
      |> Imagery.Images.create_image()

    image
  end
end
