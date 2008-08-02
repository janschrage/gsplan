class Teamcommitment < ActiveRecord::Base
  belongs_to :team
  belongs_to :project
  
  def teamname
    @team = Team.find_by_id(team_id)
    "#{@team.name}"
  end

  def projectname
    @project = Project.find_by_id(project_id)
    "#{@project.name}"
  end

end
