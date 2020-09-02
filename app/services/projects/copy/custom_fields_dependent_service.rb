#-- encoding: UTF-8

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2020 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

module Projects::Copy
  class CustomFieldsDependentService < Dependency
    def self.human_name
      I18n.t('copy_project.project_custom_fields')
    end

    ##
    # Custom fields are currently always copied
    def self.should_copy?(*)
      true
    end

    protected

    def copy_dependency(params:)
      # Copy enabled custom fields and their values
      target.custom_field_values = source.custom_value_attributes

      # Mark errors for invalid custom fields
      target.custom_values.each do |cv|
        next if cv.valid?

        add_error! CustomField, cv.errors
      end

      # Reject the invalid custom values
      # to ensure the project can be saved
      target.custom_values = target.custom_values.select(&:save)
    end
  end
end