require 'json'

class PicturePicker
  attr_reader :data, :min_score

  def initialize(file_path)
    file_path_valid?(file_path)

    file = File.open file_path
    @data = JSON.load file
  end

  def most_similar_pics(args)
    @min_score = (args[:min_score] || 0)
    chosen_descs = get_descs(args[:chosen_pic])
    other_descs = get_other_descs(args[:chosen_pic])
    pics_ranked = rank_similarities(chosen_descs, other_descs)
    select_best_pics(pics_ranked, args[:batch] || 1)
  end

  private

  def file_path_valid?(file_path)
    raise "No such file @ #{file_path}" unless File.file? file_path
  end

  def get_descs(chosen_pic)
    data[chosen_pic].map do |chosen_data|
      chosen_data['description'] if min_score < chosen_data['score']
    end.compact
  end

  def get_other_descs(chosen_pic)
    other_descs = {}
    data.keys.map do |pic|
      next if pic == chosen_pic

      other_descs[pic] = get_descs(pic)
    end
    other_descs
  end

  def rank_similarities(chosen_descs, other_descs)
    pics_ranked = {}
    other_descs.each do |pic, descs|
      pics_ranked[pic] = 0
      joined_desc = descs + chosen_descs
      pics_ranked[pic] = joined_desc.length - joined_desc.uniq.length
    end
    pics_ranked
  end

  def select_best_pics(pics_ranked, batch)
    best_pics =
      pics_ranked.sort_by(&:last).slice(pics_ranked.length - batch, batch)
    best_pics.map { |pic| pic[0] }.reverse
  end
end
