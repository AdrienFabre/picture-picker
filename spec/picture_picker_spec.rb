require 'picture_picker'

describe PicturePicker do
  let(:file_path) { 'spec/data.json' }
  let(:batch) { 3 }
  let(:min_score) { 0.85 }
  subject(:picture_picker) { described_class.new(file_path) }

  describe 'select the most similar images' do
    context 'taking into account only the description' do
      it 'retuns the picture with the highest similarity score' do
        picture = '1.jpg'
        expect(picture_picker.most_similar_pics(chosen_pic: picture)).to eq(
          %w[16.jpg]
        )
      end
      it 'retuns 3 pictures with the highest similarity score' do
        picture = '1.jpg'
        expect(
          picture_picker.most_similar_pics(chosen_pic: picture, batch: batch)
        ).to eq(%w[16.jpg 15.jpg 2.jpg])
      end
    end
    context 'taking into account the description and the score' do
      it 'retuns the picture with the highest similarity score' do
        picture = '1.jpg'
        expect(
          picture_picker.most_similar_pics(
            chosen_pic: picture, min_score: min_score
          )
        ).to eq(%w[18.jpg])
      end
      it 'retuns 3 pictures with the highest similarity score' do
        picture = '1.jpg'
        expect(
          picture_picker.most_similar_pics(
            chosen_pic: picture, min_score: min_score, batch: batch
          )
        ).to eq(%w[18.jpg 17.jpg 13.jpg])
      end
    end
  end
  describe 'returns an error message' do
    it 'raises an error if the file is not found' do
      absent_file_path = './spec/absent_file.log'
      expect { described_class.new(absent_file_path) }.to raise_error(
        RuntimeError,
        "No such file @ #{absent_file_path}"
      )
    end
  end
end
