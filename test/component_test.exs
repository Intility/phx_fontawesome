defmodule PhxFontawesomeFreeTest do
  use ComponentCase
  alias PhxFontawesomeFree

  test "can render fontawesome solid icon correctly" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <PhxFontawesomeFree.Solid.basketball />
      """)

    assert html =~ "<svg class="
    assert html =~ "Font Awesome Free"
  end
end
