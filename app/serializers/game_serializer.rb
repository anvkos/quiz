class GameSerializer < ActiveModel::Serializer
  attributes :id, :score, :finished
end
