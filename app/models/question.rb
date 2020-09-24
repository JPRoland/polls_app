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

    def results
        answer_choices_with_counts = self.answer_choices
            .select("answer_choices.text, COUNT(response.id) as num_responses")
            .left_outer_joins(:responses)
            .group("answer_choices.id")

        answer_choices_with_counts.inject({}) do |results, answer_choice|
            results[answer_choice.text] = answer_choice.num_responses; results
        end
    end
end
