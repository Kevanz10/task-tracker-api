require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'requires a description' do
      task = build(:task, description: nil)

      expect(task).not_to be_valid
      expect(task.errors[:description]).to include("can't be blank")
    end
  end
end
