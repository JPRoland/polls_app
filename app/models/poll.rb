# == Schema Information
#
# Table name: polls
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  author_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Poll < ApplicationRecord
    validates :title, presence: true

    belongs_to :author,
        class_name: 'User',
        foreign_key: :author_id,
        primary_key: :author

    has_many :questions,
        class_name: 'Question',
        primary_key: :id,
        foreign_key: :poll_id
end
