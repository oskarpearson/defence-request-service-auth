role = Role.where(name: "admin").first_or_create
cso_role = Role.where(name: "cso").first_or_create
cco_role = Role.where(name: "cco").first_or_create
solicitor_role = Role.where(name: "solicitor").first_or_create

rota_app    = GovernmentApplication.all.select { |ga| ga.oauth_application.name == "Rota" }.first
service_app = GovernmentApplication.all.select { |ga| ga.oauth_application.name == "Service" }.first

Permission.where(role: role,
                 user: User.where(email: "user2@example.com").first,
                 government_application: service_app,
                 organisation: Organisation.where(slug: "example-org".first)).first_or_create
Permission.where(role: role,
                 user: User.where(email: "user2@example.com").first,
                 government_application: rota_app,
                 organisation: Organisation.where(slug: "example-org".first)).first_or_create

(1..5).each do |i|
  Permission.where(role: cso_role,
                   user: User.where(email: "cso#{i}@example.com").first,
                   government_application: service_app,
                   organisation: Organisation.where(slug: "custody-suite").first
                  ).first_or_create

  Permission.where(role: cco_role,
                   user: User.where(email: "cco#{i}@example.com").first,
                   government_application: service_app,
                   organisation: Organisation.where(slug: "capita").first,
                  ).first_or_create

  Permission.where(role: solicitor_role,
                   user: User.where(email: "solicitor#{i}@example.com").first,
                   government_application: service_app,
                   organisation: Organisation.where(slug: "law-firm").first
                  ).first_or_create
end