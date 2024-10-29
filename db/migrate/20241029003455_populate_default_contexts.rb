class PopulateDefaultContexts < ActiveRecord::Migration[7.2]
  def change
    Context.create(name: "age", display_name: "Age")
    Context.create(name: "class", display_name: "Class")
    Context.create(name: "race-ethnicity", display_name: "Race/Ethnicity")
    Context.create(name: "religion", display_name: "Religion")
    Context.create(name: "disability", display_name: "Disability")
    Context.create(name: "neurodiversity", display_name: "Neurodiversity")
    Context.create(name: "gender", display_name: "Gender")
    Context.create(name: "lgbtqia", display_name: "LGBTQIA+ Status")
    Context.create(name: "pronouns", display_name: "Pronouns")
    Context.create(name: "pronoun_feelings", display_name: "Pronoun Feelings")
    Context.create(name: "identity_affinities", display_name: "Identity Affinities")
    Context.create(name: "identity_reflection", display_name: "Identity Reflection")
  end
end
