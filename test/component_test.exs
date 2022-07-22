defmodule PhxFontawesome.FreeTest do
  use ComponentCase
  alias PhxFontawesome.Free

  test "can render fontawesome-free solid icon with current color correctly" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <PhxFontawesome.Free.Solid.basketball />
      """)

    assert html =~ "<svg class="
    assert html =~ "currentColor"
  end

  test "can render fontawesome-free solid icon with current color correctly via render component" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <PhxFontawesome.Free.Solid.render icon="basketball" />
      """)

    assert html =~ "<svg class="
    assert html =~ "currentColor"

    html =
      rendered_to_string(~H"""
      <PhxFontawesome.Free.Solid.render icon={:basketball} />
      """)

    assert html =~ "<svg class="
    assert html =~ "currentColor"
  end

  test "can render fontawesome-free regular icon with current color correctly" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <PhxFontawesome.Free.Regular.user />
      """)

    assert html =~ "<svg class="
    assert html =~ "currentColor"
  end

  test "can render fontawesome-free regular icon with current color correctly via render component" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <PhxFontawesome.Free.Regular.render icon="user" />
      """)

    assert html =~ "<svg class="
    assert html =~ "currentColor"

    html =
      rendered_to_string(~H"""
      <PhxFontawesome.Free.Regular.render icon={:user} />
      """)

    assert html =~ "<svg class="
    assert html =~ "currentColor"
  end

  test "can forward extra params to the underlying svg element" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <PhxFontawesome.Free.Regular.user zoid="berg" />
      """)

    assert html =~ "zoid"
    assert html =~ "berg"
  end
end
