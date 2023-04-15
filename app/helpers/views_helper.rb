# frozen_string_literal: true

# Views helper
module ViewsHelper
  def show_field(label, value, comment = nil)
    render partial: 'shared_partials/show_field',
           locals: {
             label: label,
             value: value,
             comment: comment
           }
  end
end
