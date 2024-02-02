defmodule Acl.Repo.Migrations.CreateAclRules do
  use Ecto.Migration

  def change do
    create table(:acl_rules) do
      add :role,
          references(:acl_roles,
            column: :role,
            type: :string,
            on_delete: :delete_all,
            primary_key: true
          )

      add :resource_id,
          references(:acl_resources, column: :id, type: :id, on_delete: :delete_all, primary_key: true)

      add :action, :string, default: nil
      add :allowed, :boolean, default: false
      add :permission, :int, default: 1
      add :condition, :int, default: 1
      add :where_field, :string, default: nil
      add :where_value, :string, default: nil
      add :where_cond, :string, default: nil

      timestamps(type: :utc_datetime)
    end

    create index(:acl_rules, [:role])
    create index(:acl_rules, [:resource_id])
    create index(:acl_rules, [:role, :resource_id])
  end
end
