# == Schema Information
#
# Table name: responses
#
#  id               :bigint           not null, primary key
#  respondent_id    :bigint           not null
#  answer_choice_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Response < ApplicationRecord
    

    belongs_to :respondent,
        class_name: 'User',
        foreign_key: :respondent_id,
        primary_key: :id

    belongs_to :answer_choice,
        class_name: 'AnswerChoice',
        foreign_key: :answer_choice_id,
        primary_key: :id

    has_one :question,
        through: :answer_choice,
        source: :question


    validate :respondent_not_poll_author, unless: -> { answer_choice.nil? }
    validate :not_duplicate_response, unless: -> { answer_choice.nil? }

    def sibling_responses
        self.question.responses.where.not(id: self.id)
    end

    def respondent_already_answered?
        sibling_responses.exists?(respondent_id: self.respondent_id)
    end

    private
    def not_duplicate_response
        if respondent_already_answered?
            errors[:respondent_id] << 'User response already recorded'
        end
    end

    def respondent_not_poll_author
        poll_author_id = Poll
            .joins(questions: :answer_choices)
            .where('answer_choice_id = ?', self.answer_choice_id)
            .pluck('polls.author_id')
            .first

        if poll_author_id == self.respondent_id
            errors[:respondent_id] << 'cannot be poll author'
        end
    end
end
