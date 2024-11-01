defmodule Imagery.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :prompt, :string
    field :image_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:prompt, :image_url])
    |> validate_required([:prompt])
  end
end
