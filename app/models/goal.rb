class Goal < ApplicationRecord
    scope :chronological, -> {order 'updated_at DESC'}
end
