require 'json'

class PicturePicker
  attr_reader :data, :minimum_score

  def initialize(pictures_data_path)
    file = File.open pictures_data_path
    @data = JSON.load file
  end

  def most_similar_picture(args)
    @minimum_score = (args[:minimum_score] || 0)
    targeted_descriptions = get_descriptions(args[:picture_selected])
    pictures_descriptions = get_other_descriptions(args[:picture_selected])
    pictures_ranked =
      rank_similarities(targeted_descriptions, pictures_descriptions)
    select_best_pictures(pictures_ranked, args[:quantity_wanted] || 1)
  end

  private

  def get_descriptions(picture_selected)
    data[picture_selected].map do |targeted_data|
      targeted_data['description'] if minimum_score < targeted_data['score']
    end
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

  def select_best_pictures(pictures_ranked, quantity)
    pictures_ranked.sort_by { |k, v| v }.slice(
      pictures_ranked.length - quantity,
      quantity
    )
      .map { |picture| picture[0] }.reverse
  end
end
