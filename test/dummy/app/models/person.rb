class Person < ActiveRecord::Base
  belongs_to :department

  @@titles = [{id: 1, title: 'Mr'}, {id: 2, title: 'Mrs'}, {id: 3, title: 'Miss'}]

  validates :name, presence: true

  validate :check_boxes_error
  validate :radio_buttons_error

  def self.titles
    @@titles
  end

  def has_department?(department = nil)
    false
  end

  def check_boxes_error
    errors.add :check_boxes_error, I18n.t('activerecord.errors.models.person.check_boxes_error.invalid')
  end

  def radio_buttons_error
    errors.add :radio_buttons_error, I18n.t('activerecord.errors.models.person.radio_buttons_error.invalid')
  end
end
