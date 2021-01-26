defmodule Fora.Kontos.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  @hash_algorithm :sha256
  @rand_size 32

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invites" do
    field :email, :string
    field :token, :binary
    field :role, Ecto.Enum, values: [:normal, :admin]
    field :redeemed_at, :naive_datetime
    belongs_to :invited_by, Fora.Kontos.User

    timestamps()
  end

  @doc false
  def changeset(invites, attrs) do
    token = :crypto.strong_rand_bytes(@rand_size)

    invites
    |> cast(attrs, [:invite_key, :email, :redeemed_at])
    |> validate_required([:invite_key, :email, :redeemed_at])
  end

  @doc """
  Builds a token with a hashed counter part.

  The non-hashed token is sent to the user email while the
  hashed part is stored in the database, to avoid reconstruction.
  The token is valid for a week as long as users don't change
  their email.
  """
  def build_invite_token(send_to, invited_by, role) do
    build_hashed_token(send_to, invited_by, role)
  end

  defp build_hashed_token(send_to, invited_by, role) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %__MODULE__{
       token: hashed_token,
       email: send_to,
       invited_by_id: invited_by.id,
       role: role
     }}
  end

  @doc """
  Marks the invite as redeemed
  """
  def redeem_changeset(invite) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(invite, redeemed_at: now)
  end
end
