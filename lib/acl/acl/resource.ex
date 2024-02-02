defmodule Acl.ACL.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "acl_resources" do
    field :parent, :string
    field :resource, :string

    has_many :rules, Acl.ACL.Rule, foreign_key: :resource_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:resource, :parent])
    |> validate_required([:resource])
    |> unique_constraint(:resource)
  end
end
