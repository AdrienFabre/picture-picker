require 'picture_picker'

describe PicturePicker do
  let(:pictures_data_path) { 'spec/data.json' }

  subject(:picture_picker) { described_class.new(pictures_data_path) }

  describe 'select the most similar images' do
    it 'retuns the picture with the highest similarity score' do
      picture = '1.jpg'
      expect(picture_picker.most_similar_picture(picture)).to eq('16.jpg')
    end
  end
end
