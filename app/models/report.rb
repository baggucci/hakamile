class Report < ApplicationRecord
  belongs_to :reporter
  belongs_to :reported
  belongs_to :reportable, polymorphic: true
end
