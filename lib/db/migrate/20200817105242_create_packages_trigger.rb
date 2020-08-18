# frozen_string_literal: true

class CreatePackagesTrigger < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE FUNCTION trg_update_indexed()
        RETURNS trigger AS
      $func$
      BEGIN
         NEW.indexed := NEW.checksum = OLD.checksum;
         RETURN NEW;
      END
      $func$  LANGUAGE plpgsql;

      CREATE TRIGGER update_indexed
      BEFORE UPDATE ON packages
      FOR EACH ROW EXECUTE PROCEDURE trg_update_indexed();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER update_indexed ON packages;
      DROP FUNCTION trg_update_indexed();
    SQL
  end
end
