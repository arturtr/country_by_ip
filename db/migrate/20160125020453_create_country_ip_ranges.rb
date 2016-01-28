class CreateCountryIpRanges < ActiveRecord::Migration[5.0]
  def change
    create_table :country_ip_ranges do |t|
      t.string :country_name, null: false
      t.string :country_short_name
      t.inet :from_ip, null: false
      t.inet :to_ip, null: false

      t.timestamps
    end
    add_index :country_ip_ranges, [:from_ip, :to_ip]
    add_index :country_ip_ranges, :to_ip
  end
end
