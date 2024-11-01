defmodule ImageryWeb.ImageLive.FormComponent do
  use ImageryWeb, :live_component

  alias Imagery.Images

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="image-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:prompt]} type="text" label="Prompt" />
        <:actions>
          <.button phx-disable-with="Creating...">Create Image</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{image: image} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Images.change_image(image))
     end)}
  end

  @impl true
  def handle_event("validate", %{"image" => image_params}, socket) do
    changeset = Images.change_image(socket.assigns.image, image_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"image" => image_params}, socket) do
    save_image(socket, socket.assigns.action, image_params)
  end

  defp save_image(socket, :edit, image_params) do
    case Images.update_image(socket.assigns.image, image_params) do
      {:ok, image} ->
        notify_parent({:saved, image})

        {:noreply,
         socket
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_image(socket, :new, image_params) do
    case Images.create_image(image_params) do
      {:ok, image} ->
        dispatch_create_image_process(image)
        notify_parent({:saved, image})

        {:noreply,
         socket
         |> put_flash(:info, "Image created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp dispatch_create_image_process(image) do
    parent = self()

    Task.Supervisor.start_child(Imagery.TaskSupervisor, fn ->
      {:ok, url} = Imagery.AI.generate_image(image.prompt)

      case Images.update_image(image, %{image_url: url}) do
        {:ok, image} ->
          send(parent, {__MODULE__, {:saved, image}})

        {:error, changeset} ->
          Logger.error(inspect(changeset))
      end
    end)
  end
end
