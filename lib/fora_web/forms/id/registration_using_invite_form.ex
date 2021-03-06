defmodule ForaWeb.Id.RegistrationUsingInviteForm do
  use Ecto.Schema
  use ForaWeb.Forms
  import Ecto.Changeset

  @derive {Inspect, except: [:password]}
  @primary_key false
  embedded_schema do
    field :email
    field :password
    field :first_name
    field :last_name
    field :invitation_token
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:password, :first_name, :last_name])
    |> validate_required([:password, :first_name])
    |> validate_length(:password, min: 12, max: 80)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
  end
end
