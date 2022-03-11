class Event < ApplicationRecord
  acts_as_paranoid

  belongs_to :ngo, inverse_of: :events
  has_many :shifts, -> { order(starts_at: :asc) }, dependent: :destroy, inverse_of: :event
  has_many :available_shifts, -> { available }, class_name: "Shift"
  has_many :future_shifts, -> { upcoming }, class_name: "Shift"

  validates :title, length: { in: 1..100 }
  validates :address, presence: true
  validates :shifts, presence: true
  validates :person, presence: true

  accepts_nested_attributes_for :shifts, allow_destroy: true

  scope :with_available_shifts, -> {
          published
            .where(id: Shift.available.pluck(:event_id).uniq)
            .includes(:available_shifts, :ngo)
            .order("shifts.starts_at")
            .references(:available_shifts)
        }

  scope :with_upcoming_shifts, -> {
          published
            .upcoming
            .includes(:shifts, :ngo)
            .order("shifts.starts_at")
        }

  scope :upcoming, -> { where(id: Shift.upcoming.pluck(:event_id).uniq) }
  scope :past, -> { where(id: Shift.past.pluck(:event_id).uniq) }
  scope :pending, -> { where(published_at: nil) }
  scope :published, -> { where.not(published_at: nil) }

  def state
    %w(deleted published).each { |state| return state if send("#{state}?") }
    "pending"
  end

  def published?
    published_at.present?
  end

  def pending?
    published_at.blank?
  end

  def publish!
    update(published_at: Time.now) unless published?
  end

  def self.filter(scope = nil, order = nil)
    scope ||= :all
    valid_scope = [:all, :past, :upcoming].include? scope
    raise ArgumentError, "Invalid scope given" unless valid_scope
    send(scope).try(:order_by, order)
  end

  def self.order_by_for_select
    [:address, :title]
  end

  def earliest_shift
    shifts.first
  end

  def starts_at
    available_shifts.first.try(:starts_at) || shifts.first.try(:starts_at)
  end

  def ends_at
    available_shifts.last.try(:starts_at) || shifts.last.try(:starts_at)
  end

  def volunteers_needed
    available_shifts.map(&:volunteers_needed).inject(:+) ||
      shifts.map(&:volunteers_needed).inject(:+)
  end

  def volunteers_count
    available_shifts.map(&:volunteers_count).inject(:+) ||
      shifts.map(&:volunteers_count).inject(:+)
  end

  def ngo_volunteers_needed
    shifts.map(&:volunteers_needed).inject(:+)
  end

  def ngo_volunteers_count
    shifts.map(&:volunteers_count).inject(:+)
  end

  def progress_bar(user = nil, filter = nil)
    user_shift_count =
      filtered_shift_list(filter)
        .joins(:participations)
        .where(participations: { user_id: user.try(:id) })
        .count

    ProgressBar.new(
      progress: volunteers_count,
      total: volunteers_needed,
      offset: user_shift_count,
    )
  end

  private

  def filtered_shift_list(filter)
    filter == "available" ? available_shifts : shifts
  end

  def self.order_by(order)
    valid_order = [nil, :address, :title].include? order
    raise ArgumentError, "Invalid order key given" unless valid_order
    send :order, order
  end
end
