Sequel.migration do
  up do
    alter_table(:orders) do
      set_column_type :created_on, DateTime
    end
  end
end
