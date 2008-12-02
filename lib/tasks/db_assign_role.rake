namespace :db do
  desc "'Assigns a role to a user."
  
  task :assign_role => :environment do
    unless ENV.include?("user") && ENV.include?("role")
      raise "usage: rake db:assign_role user=<user> role=<role>" 
    end

    #Role
    role = Role.find_by_name(ENV['role'])
    raise "Role not found." unless role
 
    #User
    user = User.find_by_name(ENV['user'])
    raise "User not found." unless user

    user.roles << role
    user.save!

    puts "Done."   
  end
end
    
