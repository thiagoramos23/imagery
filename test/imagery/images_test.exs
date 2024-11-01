defmodule Imagery.ImagesTest do
  use Imagery.DataCase

  alias Imagery.Images

  describe "images" do
    alias Imagery.Images.Image

    import Imagery.ImagesFixtures

    @invalid_attrs %{prompt: nil, image_url: nil}

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Images.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{prompt: "some prompt", image_url: "some image_url"}

      assert {:ok, %Image{} = image} = Images.create_image(valid_attrs)
      assert image.prompt == "some prompt"
      assert image.image_url == "some image_url"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{prompt: "some updated prompt", image_url: "some updated image_url"}

      assert {:ok, %Image{} = image} = Images.update_image(image, update_attrs)
      assert image.prompt == "some updated prompt"
      assert image.image_url == "some updated image_url"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Images.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end
end
