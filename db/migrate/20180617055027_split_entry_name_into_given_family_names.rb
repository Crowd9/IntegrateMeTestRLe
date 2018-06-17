class SplitEntryNameIntoGivenFamilyNames < ActiveRecord::Migration
  def up
    add_column :entries, :given_name, :string
    add_column :entries, :family_name, :string

    Entry.reset_column_information

    Entry.where.not(name: nil).find_each do |e|
      puts e.name
      name_parts = e.name.split(" ", 2)
      e.given_name = name_parts[0]
      e.family_name = name_parts[1]
      e.save!
    end

    remove_column :entries, :name
  end

  def down
    add_column :entries, :name, :string

    Entry.reset_column_information

    Entry.where.not(given_name: nil).find_each do |e|
      e.name = "#{e.given_name} #{e.family_name}"
      e.save!
    end

    remove_column :entries, :given_name
    remove_column :entries, :family_name
  end
end
