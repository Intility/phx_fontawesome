defmodule Mix.Tasks.PhxFontawesome.Generate do
  @moduledoc false
  use Mix.Task
  require Logger

  @src_path "./assets/node_modules/@fortawesome"
  @dest_path "./lib/phx_fontawesome"

  @shortdoc "Short doc here"
  def run(_) do
    sets = Application.get_env(:phx_fontawesome, :types) || ["regular", "solid"]

    with {:ok, name} <- File.ls(@src_path),
         fontsets <- Enum.zip(name, Enum.map(name, &list_fontsets(&1, sets))) do
      for {namespace, fontset} <- fontsets, do: Enum.each(fontset, &build_module(namespace, &1))
    else
      {:error, :enoent} ->
        Logger.error(
          "Directory #{Path.absname(@src_path)} does not exist.\n" <>
            "Please install desired font set using ie. 'yarn add @fortawesome/fontawesome-free' " <>
            "from the assets directory."
        )
    end

    Mix.Task.run("format")
  end

  @spec list_fontsets(directory :: String.t(), sets :: [String.t()]) ::
          [{String.t(), [String.t()]}] | {:error, :enoent}
  defp list_fontsets(directory, sets) do
    with {:ok, can_process} <- File.ls(Path.join([@src_path, directory, "svgs"])),
         {:ok, to_process} <- intersect(can_process, sets),
         to_process_paths <- Enum.map(to_process, &Path.join([@src_path, directory, "svgs", &1])),
         fontset_files <- Enum.map(to_process_paths, &list_directory/1) do
      fontset_files
    else
      {:error, :enoent} = reply ->
        Logger.error(
          "Could not find directory #{Path.join(Path.absname(Path.join(@src_path, directory)), "svgs")}.\n" <>
            "Please make sure that the #{directory} fonts are properly installed."
        )

        reply
    end
  end

  @spec list_directory(directory :: String.t()) :: {String.t(), [String.t()]}
  defp list_directory(directory) do
    files =
      File.ls!(directory)
      |> Enum.filter(&(Path.extname(&1) == ".svg"))
      |> Enum.sort()

    {directory, files}
  end

  @spec intersect([String.t()], [String.t()]) :: [String.t()]
  defp intersect(a, b),
    do: {:ok, MapSet.new(a) |> MapSet.intersection(MapSet.new(b)) |> MapSet.to_list()}

  @spec build_module(String.t(), {String.t(), [String.t()]}) :: :ok
  defp build_module(ns, {fontset, files}) when is_list(files) do
    module_name =
      with module_name <- String.split(ns, "-") |> Enum.map(&String.capitalize/1) |> Enum.join(),
           fontset_name <- Path.basename(fontset) |> String.capitalize(),
           do: "Phx#{module_name}.#{fontset_name}"

    file = """
    defmodule #{module_name} do
      @moduledoc \"\"\"
      Icon name can be the function or passed in as a type eg.

      ## Example

        <PhxFontawesomeFree.Solid.angle_up class="my-custom-class" />
        <PhxFontawesomeFree.Regular.render icon="angle_down" class="my-custom-class" />

      \"\"\"
      use Phoenix.Component

      def render(%{icon: icon_name} = assigns) when is_atom(icon_name) do
        apply(__MODULE__, icon_name, [assigns])
      end

      def render(%{icon: icon_name} = assigns) do
        icon_name = String.to_existing_atom(icon_name)
        apply(__MODULE__, icon_name, [assigns])
      end
    """

    dest_path = Path.join([@dest_path, String.replace(ns, "-", "_")])
    dest_file = Path.join(dest_path, "#{Path.basename(fontset)}.ex")
    unless File.exists?(dest_path), do: File.mkdir_p!(dest_path)
    if File.exists?(dest_file), do: File.rm!(dest_file)

    output_stream = File.stream!(dest_file, [:utf8, :delayed_write, :append], :line)

    # Write beginning of file to output stream
    Stream.run(Stream.into([file], output_stream))

    # Write all functions to output stream
    response =
      Enum.map(files, &Path.join(fontset, &1))
      |> Task.async_stream(&stream_file/1)
      |> Enum.map(fn {:ok, stream} ->
        Stream.run(Stream.into(stream, output_stream))
      end)

    # Write the final "end" statement to output stream
    Stream.run(Stream.into(["\nend"], output_stream))

    Logger.info(
      "Successfully wrote #{Path.absname(dest_file)} (containing #{length(response)} SVG components). "
    )
  end

  defp build_function(svg_data, name) do
    """
      def #{name}(assigns) do
        assigns =
          assigns
          |> assign_new(:class, fn -> nil end)
          |> assign_new(:rest, fn -> assigns_to_attributes(assigns, ~w(class)a) end)

        ~H\"\"\"
        #{svg_data}
        \"\"\"
      end
    """
  end

  @spec function_name(String.t()) :: String.t()
  defp function_name(name) do
    Path.basename(name, ".svg")
    |> String.replace("-", "_")
    |> ensure_valid_function_name()
  end

  @spec ensure_valid_function_name(String.t()) :: String.t()
  defp ensure_valid_function_name("0"), do: "zero"
  defp ensure_valid_function_name("1"), do: "one"
  defp ensure_valid_function_name("2"), do: "two"
  defp ensure_valid_function_name("3"), do: "three"
  defp ensure_valid_function_name("4"), do: "four"
  defp ensure_valid_function_name("5"), do: "five"
  defp ensure_valid_function_name("6"), do: "six"
  defp ensure_valid_function_name("7"), do: "seven"
  defp ensure_valid_function_name("8"), do: "eight"
  defp ensure_valid_function_name("9"), do: "nine"
  defp ensure_valid_function_name(name), do: name

  @spec stream_file(String.t()) :: Stream.t()
  defp stream_file(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.replace(&1, ~r/<svg /, "<svg class={@class} {@rest} "))
    |> Stream.map(&String.replace(&1, ~r/<path/, "  <path"))
    |> Stream.map(&build_function(&1, function_name(file_path)))
  end
end
