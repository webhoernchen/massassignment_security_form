module TestTables

  def create_tables
    drop_old_table_definition
    create_tables_with_new_definition
  end

  private
  def drop_old_table_definition
    connection = ActiveRecord::Base.connection
    connection.tables.grep(/massassignment_security_form_[a-z_]*/).each do |table|
      connection.drop_table(table)
    end
  end

  def create_tables_with_new_definition
    create_table_people
  end

  def create_table_people
    create_table :massassignment_security_form_people do |t|
      t.string :first_name, :last_name, :salutation
      t.date :birthday
      t.boolean :terms_of_use
    end
  end

  def create_table(name, options={}, &block)
    ActiveRecord::Schema.define do
      create_table name, options do |t|
        yield(t)
      end
    end
  end
end
