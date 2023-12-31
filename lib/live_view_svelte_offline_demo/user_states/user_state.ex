defmodule LiveViewSvelteOfflineDemo.UserStates.UserState do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_states" do
    field :state, :map
    belongs_to :user, LiveViewSvelteOfflineDemo.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_state, attrs) do
    user_state
    |> cast(attrs, [:state, :user_id])
    |> validate_required([:state, :user_id])
    |> validate_length(:state, is: 2)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id)
  end

  # TODO: add validation for state map
end
