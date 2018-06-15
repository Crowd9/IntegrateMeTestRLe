class AddMailingListIdToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :mailing_list_id, :string

    Competition.reset_column_information

    Competition.find(1).update!(mailing_list_id: "a94641097a")
    Competition.find(2).update!(mailing_list_id: "4827de065a")
  end
end
