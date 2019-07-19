require 'json'

class PicturePicker
  attr_reader :data

  def initialize(pictures_data_path)
    file = File.open pictures_data_path
    @data = JSON.load file
  end

  def most_similar_picture(picture_selected)
    targeted_descriptions =
      data[picture_selected].map do |targeted_data|
        targeted_data['description']
      end

    pictures_descriptions = Hash.new(0)
    data.keys.map do |picture|
      next if picture == picture_selected

      pictures_descriptions[picture] = []
      data[picture].map do |picture_data|
        pictures_descriptions[picture] << picture_data['description']
      end
    end

    pictures_rank = Hash.new(0)

    pictures_descriptions.each do |picture, descriptions|
      pictures_rank[picture] = 0
      targeted_descriptions.each do |description|
        if descriptions.include?(description)
          if pictures_rank[picture].positive?
            pictures_rank[picture] += 1
          else
            pictures_rank[picture] = 1
          end
        end
      end
    end
    pictures_rank.sort_by { |k, v| v }.reverse.first[0]
  end
end
