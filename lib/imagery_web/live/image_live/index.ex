defmodule ImageryWeb.ImageLive.Index do
  use ImageryWeb, :live_view

  alias Imagery.Images
  alias Imagery.Images.Image

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :images, Images.list_images())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Image")
    |> assign(:image, Images.get_image!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Image")
    |> assign(:image, %Image{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Images")
    |> assign(:image, nil)
  end

  @impl true
  def handle_info({ImageryWeb.ImageLive.FormComponent, {:saved, image}}, socket) do
    {:noreply, stream_insert(socket, :images, image)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    image = Images.get_image!(id)
    {:ok, _} = Images.delete_image(image)

    {:noreply, stream_delete(socket, :images, image)}
  end
end
