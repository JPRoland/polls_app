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

end
