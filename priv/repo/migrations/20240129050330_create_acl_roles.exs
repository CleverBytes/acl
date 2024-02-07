defmodule Acl.Repo.Migrations.CreateAclRoles do
  use Ecto.Migration

  def change do
    create table(:acl_roles, primary_key: false) do
      add :role, :string, null: false, primary_key: true
      add :parent, :string, default: nil

      timestamps(type: :utc_datetime)
    end

    create unique_index(:acl_roles, [:role])
  end
end
