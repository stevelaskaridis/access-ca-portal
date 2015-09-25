# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

scientific_fields_list = [
    { en: "Other",                                    el: "Άλλο",                                      },
    { en: "Astrophysics and Particle Physics",        el: "Αστροφυσική και Σωματιδιακή Αστροφυσική",   },
    { en: "Bioinformatics and applied Biomedicine",   el: "Εφαρμογές Βιοϊατρικής και Βιοπληροφορικής", },
    { en: "Computational Chemistry",                  el: "Υπολογιστική Χημεία",                       },
    { en: "Geological Sciences",                      el: "Γεωεπιστήμες",                              },
    { en: "Economics",                                el: "Οικονομικά",                                },
    { en: "Fusion",                                   el: "Σύντηξη",                                   },
    { en: "Geophysics",                               el: "Γεωφυσική",                                 },
    { en: "High-energy Physics",                      el: "Φυσική Υψηλών Ενεργειών",                   },
    { en: "Mechanical Physics",                       el: "Μηχανική",                                  },
    { en: "Computer Science",                         el: "Επιστήμη Υπολογιστών",                      },
    { en: "Mathematics",                              el: "Μαθηματικά",                                },
]


scientific_fields_list.each do |rec|
  sc_f = ScientificField.new
  rec.each do |locale, val|
    I18n.locale = locale
    sc_f[:description] = val
  end
  sc_f.save!
end

positions_list = [
    { en: "Researcher", el: "Ερευνητής"           },
    { en: "Faculty",    el: "Διδακτικό Προσωπικό" },
    { en: "Staff",      el: "Προσωπικό"           },
    { en: "Student",    el: "Φοιτητής"            },
]

positions_list.each do |rec|
  pos = Position.new
  rec.each do |locale, val|
    I18n.locale = locale
    pos[:description] = val
  end
  pos.save!
end