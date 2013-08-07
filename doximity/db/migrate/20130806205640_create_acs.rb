class CreateAcs < ActiveRecord::Migration
  def change
    create_table :acs do |t|

      t.timestamps
    end
  end
end
