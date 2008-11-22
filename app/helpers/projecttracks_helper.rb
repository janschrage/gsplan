# GSPlan - Team commitment planning
#
# Copyright (C) 2008 Jan Schrage <jan@jschrage.de>
# 
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU 
# General Public License as published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with this program. 
# If not, see <http://www.gnu.org/licenses/>.

module ProjecttracksHelper
  TrackStatusImages = [ "/images/icons/ok.png",
                        "/images/icons/error.png"]

  def track_status_image(status)
    return TrackStatusImages[0] if status 
    return TrackStatusImages[1]
  end
  
  def project_by_id(project_id)
    return Project.find_by_id(project_id).name
  end
  
  def team_by_id(team_id)
    return Team.find_by_id(team_id).name
  end  
end
