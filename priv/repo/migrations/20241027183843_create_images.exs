defmodule Imagery.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :prompt, :text
      add :image_url, :text

      timestamps(type: :utc_datetime)
    end
  end
end
