defmodule ForaWeb.Forms do
  use Ecto.Schema
  @doc false
  defmacro __using__(_opts) do
    quote do
      defdelegate validate(struct, params), to: ForaWeb.Forms
      defdelegate apply(changeset), to: ForaWeb.Forms
      defdelegate apply(struct, params), to: ForaWeb.Forms
    end
  end

  def validate(struct = %struct_module{}, params) do
    struct
    |> struct_module.changeset(params)
    |> Map.put(:action, :validate)
  end

  def apply(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.apply_action(changeset, :insert)
  end

  def apply(struct = %struct_module{}, params) do
    struct
    |> struct_module.changeset(params)
    |> Ecto.Changeset.apply_action(:insert)
  end
end
