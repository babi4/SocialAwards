class DealSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :type
end
