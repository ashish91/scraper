class Url < ApplicationRecord
  enum status: { unprocessed: 0, processing: 1, processed: 2, failed: 3 }

  default_scope -> { order(created_at: :desc) }
end
