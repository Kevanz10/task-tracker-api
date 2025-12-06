class TasksController < ApplicationController
  def index
    tasks = Task.order(created_at: :desc)
    render json: tasks
  end

  def create
    task = Task.new(task_params)

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:description)
  end
end
