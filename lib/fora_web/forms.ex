defmodule ForaWeb.Forms do
  use Ecto.Schema
  @doc false
  defmacro __using__(_opts) do
    quote do
      defdelegate validate(struct, params), to: ForaWeb.Forms
      defdelegate apply(changeset), to: ForaWeb.Forms
    end
  end

  def validate(struct = %struct_module{}, params) do
    struct
    |> struct_module.changeset(params)
    |> Map.put(:action, :validate)
  end

  def apply(changeset) do
    Ecto.Changeset.apply_action(changeset, :insert)
  end
end
