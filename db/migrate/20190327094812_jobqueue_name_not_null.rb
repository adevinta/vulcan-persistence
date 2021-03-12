# Copyright 2021 Adevinta

class JobqueueNameNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :jobqueues, :name, false
  end
end
