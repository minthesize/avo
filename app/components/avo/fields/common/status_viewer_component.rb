# frozen_string_literal: true

class Avo::Fields::Common::StatusViewerComponent < Avo::BaseComponent
  def initialize(status:, label:)
    @status = status
    @label = label
  end
end
