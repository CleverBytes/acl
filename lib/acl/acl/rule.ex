defmodule Acl.ACL.Rule do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "acl_rules" do
    field :condition, :integer, default: 1
    field :where_cond, :string, default: nil
    field :where_value, :string, default: nil
    field :where_field, :string, default: nil
    field :permission, :integer, default: 1
    field :action, :string, default: nil
    field :allowed, :boolean, default: false
    field :role, :string, primary_key: true
    belongs_to :resource, Acl.ACL.Resource, references: :id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rule, attrs, resource) do
    rule
    |> cast(attrs, [:action, :permission, :role, :condition])
    |> put_assoc(:resource, resource)
    |> validate_required([:resource, :role])
  end

  def u_changeset(rule, attrs) do
    rule
    |> cast(attrs, [:action, :permission, :role, :condition, :resource_id])
    |> validate_required([:resource, :role])
  end
end
