<p align="center">
  <img src="assets/logo.png" height="128">
  <h1 align="center">PhxFontawesome</h1>
  <p align="center">
    A simple Mix task that generates Phoenix Components from Font Awesome SVG files.
  </p>
</p>

![pipeline status](https://github.com/Intility/phx_fontawesome/actions/workflows/elixir.yml/badge.svg?event=push)

## Installation

This package is [available in Hex](https://hex.pm/packages/intility/phx_fontawesome), and can be installed
by adding `phx_fontawesome` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phx_fontawesome, "~> 0.1.0", organization: "intility"}
  ]
end
```

## Generate Heex components

**Step 1 - Install desired font set**

In your Phoenix project, install desired font set using `npm` or `yarn`. Please consult the Font Awesome
[documentation](https://fontawesome.com/docs/web/setup/packages) if you run into any trouble here.

```shell
$ cd assets/
$ yarn add @fortawesome/fontawesome-free
```

**Step 2 - Choose font set types to generate**

In your `config.exs`, you may choose which types to generate `heex` components for. Defaults to `regular` and `solid`.

```elixir
config :phx_fontawesome,
  types: ["regular", "solid"]
```

**Step 3 - Generate component files**

From your project root, run `mix phx_fontawesome.generate` to create components. Generated files will be available in your
`lib/phx_fontawesome` directory.

```shell
$ mix phx_fontawesome.generate
[info]  Successfully wrote /path/to/project/my_project/lib/phx_fontawesome/fontawesome_free/regular.ex (containing 162 SVG components).
[info]  Successfully wrote /path/to/project/my_project/lib/phx_fontawesome/fontawesome_free/solid.ex (containing 1385 SVG components).
```

## Usage

Once generated, the `heex` components are part of your project, and can be used as a regular `Phoenix.Component`.

```html
<PhxFontawesomeFree.Solid.angle_up class="my-custom-class" />
<PhxFontawesomeFree.Regular.render icon="angle_down" class="my-custom-class" />
```

If you would like to apply the default styling for SVG elements, simply include the Font Awesome CSS in your `app.css` file.

```css
@import "@fortawesome/fontawesome-free/css/all.min.css";
```

Keep in mind that if you're using the non-free version of Font Awesome, make sure that you don't publish the
generated components as that would be a licensing breach.
Consider adding `/lib/phx_fontawesome/` to your `.gitignore` file, and use `mix phx_fontawesome.generate` in your deployment
pipeline to build SVG components for deployed applications.

### Credits

- Heavily inspired by the [Petal Components](https://github.com/petalframework/petal_components) project.
- Logo comes from the [Font Awesome](https://commons.wikimedia.org/wiki/File:Font_Awesome_5_brands_phoenix-framework.svg) project.
