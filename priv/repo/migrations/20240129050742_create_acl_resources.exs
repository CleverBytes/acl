defmodule Acl.Repo.Migrations.CreateAclResources do
  use Ecto.Migration

  def change do
    create table(:acl_resources) do
      add :resource, :string, null: true
      add :parent, :string, default: nil

      timestamps(type: :utc_datetime)
    end

    create unique_index(:acl_resources, [:resource])
  end
end
