require 'picture_picker'

describe PicturePicker do
  let(:pictures_data_path) { 'spec/data.json' }
  let(:quantity_wanted) { 3 }
  let(:minimum_score) { 0.85 }
  subject(:picture_picker) { described_class.new(pictures_data_path) }

  describe 'select the most similar images' do
    context 'taking into account only the description' do
      it 'retuns the picture with the highest similarity score' do
        picture = '1.jpg'
        expect(
          picture_picker.most_similar_picture(picture_selected: picture)
        ).to eq(%w[16.jpg])
      end
      it 'retuns 3 pictures with the highest similarity score' do
        picture = '1.jpg'
        expect(
          picture_picker.most_similar_picture(
            picture_selected: picture, quantity_wanted: quantity_wanted
          )
        ).to eq(%w[16.jpg 15.jpg 2.jpg])
      end
    end
    context 'taking into account the description and the score' do
      it 'retuns the picture with the highest similarity score' do
        picture = '1.jpg'
        expect(
          picture_picker.most_similar_picture(
            picture_selected: picture, minimum_score: minimum_score
          )
        ).to eq(%w[18.jpg])
      end
      it 'retuns 3 pictures with the highest similarity score' do
        picture = '1.jpg'
        expect(
          picture_picker.most_similar_picture(
            picture_selected: picture,
            minimum_score: minimum_score,
            quantity_wanted: quantity_wanted
          )
        ).to eq(%w[18.jpg 17.jpg 13.jpg])
      end
    end
  end
end
