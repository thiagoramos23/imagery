defmodule ImageryWeb.ImageLiveTest do
  use ImageryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Imagery.ImagesFixtures

  @create_attrs %{prompt: "some prompt", image_url: "some image_url"}
  @update_attrs %{prompt: "some updated prompt", image_url: "some updated image_url"}
  @invalid_attrs %{prompt: nil, image_url: nil}

  defp create_image(_) do
    image = image_fixture()
    %{image: image}
  end

  describe "Index" do
    setup [:create_image]

    test "lists all images", %{conn: conn, image: image} do
      {:ok, _index_live, html} = live(conn, ~p"/images")

      assert html =~ "Listing Images"
      assert html =~ image.prompt
    end

    test "saves new image", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/images")

      assert index_live |> element("a", "New Image") |> render_click() =~
               "New Image"

      assert_patch(index_live, ~p"/images/new")

      assert index_live
             |> form("#image-form", image: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#image-form", image: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/images")

      html = render(index_live)
      assert html =~ "Image created successfully"
      assert html =~ "some prompt"
    end

    test "updates image in listing", %{conn: conn, image: image} do
      {:ok, index_live, _html} = live(conn, ~p"/images")

      assert index_live |> element("#images-#{image.id} a", "Edit") |> render_click() =~
               "Edit Image"

      assert_patch(index_live, ~p"/images/#{image}/edit")

      assert index_live
             |> form("#image-form", image: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#image-form", image: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/images")

      html = render(index_live)
      assert html =~ "Image updated successfully"
      assert html =~ "some updated prompt"
    end

    test "deletes image in listing", %{conn: conn, image: image} do
      {:ok, index_live, _html} = live(conn, ~p"/images")

      assert index_live |> element("#images-#{image.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#images-#{image.id}")
    end
  end

  describe "Show" do
    setup [:create_image]

    test "displays image", %{conn: conn, image: image} do
      {:ok, _show_live, html} = live(conn, ~p"/images/#{image}")

      assert html =~ "Show Image"
      assert html =~ image.prompt
    end

    test "updates image within modal", %{conn: conn, image: image} do
      {:ok, show_live, _html} = live(conn, ~p"/images/#{image}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Image"

      assert_patch(show_live, ~p"/images/#{image}/show/edit")

      assert show_live
             |> form("#image-form", image: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#image-form", image: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/images/#{image}")

      html = render(show_live)
      assert html =~ "Image updated successfully"
      assert html =~ "some updated prompt"
    end
  end
end
