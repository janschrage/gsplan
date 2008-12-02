namespace :db do
  desc "'Assigns the role Teammember to all users."
  task :make_all_teammembers => :environment do

    #Team member
    role_tm = Role.find_by_name("Teammember") 
    
    users = User.find(:all)
    users.each do |user|
      user.roles << role_tm
      user.save!
    end   
  end
end
    
