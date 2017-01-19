defmodule Mnemonix.Builder do
  @moduledoc """
  Creates functions that proxy to Mnemonix ones.

  `use Mnemonix.Builder` to add all `Mnemonix.Feature` functions to a module.

  You can pass in the option `singleton: true` to create a module that uses its own name
  as a `Mnemonix.Store.Server` reference, omitting the need for the first argument to all
  `Mnemonix.Feature` functions:

  ```elixir
  iex> defmodule My.Store do
  ...>   use Mnemonix.Builder
  ...>   def start_link do
  ...>     Mnemonix.Store.Server.start_link(Mnemonix.Stores.ETS, name: __MODULE__)
  ...>   end
  ...> end
  iex> {:ok, store} = My.Store.start_link
  iex> My.Store.get(store, :a)
  nil
  iex> My.Store.put(store, :a, 1)
  iex> My.Store.get(store, :a)
  1

  iex> defmodule My.Singleton do
  ...>   use Mnemonix.Builder, singleton: true
  ...>   def start_link do
  ...>     Mnemonix.Store.Server.start_link(Mnemonix.Stores.ETS, name: __MODULE__)
  ...>   end
  ...> end
  iex> My.Singleton.start_link
  iex> My.Singleton.get(:a)
  nil
  iex> My.Singleton.put(:a, 1)
  iex> My.Singleton.get(:a)
  1
  """

  defmacro __using__(opts) do
    quote location: :keep do
      use Mnemonix.Features.Map, unquote(opts)
      use Mnemonix.Features.Bump, unquote(opts)
      use Mnemonix.Features.Expiry, unquote(opts)
    end
  end

end