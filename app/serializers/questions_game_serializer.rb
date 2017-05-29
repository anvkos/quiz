class QuestionsGameSerializer < ActiveModel::Serializer
  belongs_to :question, serializer: QuestionSerializer
  attributes :score

  def score
    object.game.score
  end
end
