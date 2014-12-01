# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
                                  
projects = Project.create([{:name => 'Start-up' },
                            {:name => 'Service Center', :additional_required => true }
                          ])
                          
labs = Lab.create([{:name => 'Greene', :projects => projects.first}
                  ])
                  

#You will probably want to change this
User.create(:email => 'admin@secret.edu', :password => 'admin', :password_confirmation => 'admin', 
            :admin => 1, :lab => labs.first)
