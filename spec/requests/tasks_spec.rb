require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  describe 'GET /tasks' do
    context 'when tasks exist' do
      let!(:oldest_task) { create(:task, description: 'Oldest task', created_at: 2.days.ago) }
      let!(:newest_task) { create(:task, description: 'Newest task', created_at: Time.current) }

      it 'returns all tasks ordered by creation time (newest first)' do
        get '/tasks'

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.first['id']).to eq(newest_task.id)
        expect(json_response.last['id']).to eq(oldest_task.id)
      end
    end
  end

  describe 'POST /tasks' do
    context 'with valid description' do
      it 'creates a new task and returns it' do
        expect {
          post '/tasks', params: { task: { description: 'New task' } }, as: :json
        }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to be_present
        expect(json_response['description']).to eq('New task')
      end
    end

    context 'with invalid description' do
      it 'returns validation errors and does not create a task' do
        expect {
          post '/tasks', params: { task: { description: nil } }, as: :json
        }.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Description can't be blank")
      end
    end
  end
end
