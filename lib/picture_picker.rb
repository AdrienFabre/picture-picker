require 'json'

class PicturePicker
  attr_reader :data

  def initialize(pictures_data_path)
    file = File.open pictures_data_path
    @data = JSON.load file
  end

  def most_similar_picture(picture_selected)
    targeted_descriptions = get_descriptions(picture_selected)
    pictures_descriptions = get_other_descriptions(picture_selected)
    pictures_ranked =
      rank_similarities(targeted_descriptions, pictures_descriptions)
    pictures_ranked.sort_by { |k, v| v }.reverse.first[0]
  end

  private

  def get_descriptions(picture_selected)
    data[picture_selected].map { |targeted_data| targeted_data['description'] }
  end

  def get_other_descriptions(picture_selected)
    pictures_descriptions = {}
    data.keys.map do |picture|
      next if picture == picture_selected

      pictures_descriptions[picture] = get_descriptions(picture)
    end
    pictures_descriptions
  end

  def rank_similarities(targeted_descriptions, pictures_descriptions)
    pictures_ranked = {}
    pictures_descriptions.each do |picture, descriptions|
      pictures_ranked[picture] = 0
      targeted_descriptions.each do |description|
        pictures_ranked[picture] += 1 if descriptions.include?(description)
      end
    end
    pictures_ranked
  end
end
