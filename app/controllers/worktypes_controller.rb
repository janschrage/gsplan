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

class WorktypesController < ApplicationController
  layout "ActScaffold"

   active_scaffold :worktype do |config|
    config.label = "Type of Work"
    config.columns = [:name, :description, :preload, :needs_review]
    list.sorting = {:name => 'ASC'}
    columns[:name].label = "Type of Work"
    columns[:description].label = "Description"
    columns[:preload].label = "Preload?"
    columns[:preload].form_ui = :checkbox
    columns[:needs_review].label = "Needs review?"
    columns[:needs_review].form_ui = :checkbox
  end
end
