defmodule ForaWeb.Id.Registration2FAForm do
  use Ecto.Schema
  use ForaWeb.Forms
  import Ecto.Changeset

  @derive {Inspect, except: [:secret_2fa]}
  @primary_key false
  embedded_schema do
    field :totp_verification
    field :secret_2fa
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:totp_verification])
    |> validate_required([:totp_verification])
    |> validate_length(:totp_verification, min: 6, max: 6)
    |> validate_totp()
  end

  defp validate_totp(changeset) do
    totp_verification = get_change(changeset, :totp_verification)
    secret_2fa = changeset.data.secret_2fa

    if totp_verification && String.length(totp_verification) == 6 do
      if :pot.totp(secret_2fa) == totp_verification do
        changeset
      else
        add_error(changeset, :totp_verification, "is invalid")
      end
    else
      changeset
    end
  end
end
