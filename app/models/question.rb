# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  text       :text             not null
#  poll_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Question < ApplicationRecord
    validates :text, presence: true

    has_many :answer_choices,
        class_name: 'AnswerChoice',
        foreign_key: :question_id,
        primary_key: :id

    belongs_to :poll,
        class_name: 'Poll',
        foreign_key: :poll_id,
        primary_key: :id

    has_many :responses,
        through: :answer_choices,
        source: :responses
end
