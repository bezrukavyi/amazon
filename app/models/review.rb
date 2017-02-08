class Review < ApplicationRecord
  include AASM

  belongs_to :book
  belongs_to :user

  aasm column: :state, whiny_transitions: false do
    state :unprocessed, initial: true
    state :approved
    state :rejected

    event :approve do
      transitions from: :unprocessed, to: :approved
    end

    event :reject do
      transitions from: :unprocessed, to: :rejected
    end
  end

  def self.assm_states
    aasm.states.map(&:name)
  end

end
