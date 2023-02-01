defmodule PhxFontawesome do
  @moduledoc """
  Render a Fontawesome icon.
  """
  use Phoenix.Component

  @doc """
  Renders a Fontawesome icon from given set and type.

  ## Example

      <!-- Render the user icon from the regular free set -->
      <PhxFontawesome icon="user" set="free" type="regular" />

      <!-- Render te user icon from the solid pro set -->
      <PhxFontawesome icon="user" set="pro" type="solid" />
  """
  def render(%{icon: _icon_name, set: "free", type: "regular"} = assigns),
    do: render_icon(assigns)

  def render(%{icon: _icon_name, set: "free", type: "solid"} = assigns),
    do: render_icon(assigns)

  def render(%{icon: _icon_name, set: "free", type: "brands"} = assigns),
    do: render_icon(assigns)

  def render(%{icon: _icon_name, set: "pro", type: "regular"} = assigns),
    do: render_icon(assigns)

  def render(%{icon: _icon_name, set: "pro", type: "solid"} = assigns),
    do: render_icon(assigns)

  def render(%{icon: _icon_name, set: "pro", type: "brands"} = assigns),
    do: render_icon(assigns)

  defp render_icon(%{icon: icon_name, set: set, type: type} = assigns) do
    ensure_module_exists(set, type)
    |> apply(ensure_icon_atom_name(icon_name), [assigns])
  end

  defp ensure_module_exists(set, type) do
    with module_names <- Enum.map([set, type], &String.capitalize/1),
         module_name <- Module.concat([PhxFontawesome | module_names]),
         do: Code.ensure_loaded!(module_name)
  end

  defp ensure_icon_atom_name(icon_name) when is_atom(icon_name), do: icon_name

  defp ensure_icon_atom_name(icon_name) when is_binary(icon_name),
    do: String.to_existing_atom(icon_name)
end
