defmodule CoraWeb.CustomComponents do
  use Phoenix.Component

  import CoraWeb.CoreComponents

  attr :text, :string, required: true

  def banner(assigns) do
    ~H"""
    <div class="bg-slate-100 m-2 p-4 rounded-xl text-xl font-extrabold bg-white">
      <h1>{@text}</h1>
    </div>
    """
  end

  attr :text, :string, required: true
  attr :nav, :string, default: "/"

  def banner_link(assigns) do
    ~H"""
    <a href={@nav}>
      <div class="border m-2 p-4 align-middle justify-center rounded-xl bg-white">
        <span class="font-bold">{@text}</span>
      </div>
    </a>
    """
  end
end
