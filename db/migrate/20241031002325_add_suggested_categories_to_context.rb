class AddSuggestedCategoriesToContext < ActiveRecord::Migration[7.2]
  def change
    add_column :contexts, :suggested_categories, :string, array: true, default: []
    add_column :contexts, :suggestions_updated_at, :datetime
  end
end
