defmodule CoraWeb.CustomComponents do
  use Phoenix.Component

  import CoraWeb.CoreComponents

  slot :inner_block, required: true
  def banner(assigns) do
    ~H"""
    <div class="bg-slate-100 m-2 p-4 rounded-xl text-xl font-extrabold bg-white">
      <h1>{render_slot(@inner_block)}</h1>
    </div>
    """
  end

  attr :href, :string, default: "/"

  slot :inner_block, required: true
  def banner_link(assigns) do
    ~H"""
    <a href={@href}>
      <div class="border my-2 p-4 align-middle justify-center rounded-xl bg-gray-100">
        <span class="font-bold">{render_slot(@inner_block)}</span>
      </div>
    </a>
    """
  end

  attr :href, :string, default: "/"
  slot :inner_block, required: true
  def a(assigns) do
    ~H"""
    <a href={@href}>
      <div class="inline-flex gap-x-2 rounded-xl bg-gray-100 p-2 w-fit hover:bg-gray-200 transition duration-300">
        <.icon name="hero-arrow-right"/>
        <span class="font-bold">{render_slot(@inner_block)}</span>
      </div>
    </a>
    """
  end
end
