class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find_by(id: params[:id])
    if !@task
      redirect_to tasks_path(@task), :flash => { :error => "Could not find task with id: #{params[:id]}" }
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new task_params
    if @task.save
      redirect_to task_path(@task.id), { :flash => { :success => "Task has been added" } }
    else
      redirect_to :new, :flash => { :error => "Failed to add task" }
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
    if !@task
      redirect_to tasks_path, :flash => { :error => "Could not find task with id: #{params[:id]}" }
    end
  end

  def update
    @task = Task.find_by(id: params[:id])

    if @task
      if @task.update task_params
        redirect_to task_path(@task.id), { :flash => { :success => "Task has been updated" } }
      else
        redirect_to :edit, :flash => { :error => "Failed to update task" }
      end
    else
      redirect_to root_path, status: 302, :flash => { :error => "Could not find task with id: #{params[:id]}" }
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    if @task
      if @task.destroy
        redirect_to root_path, { :flash => { :success => "Task has been removed" } }
      else
        redirect_to root_path, :flash => { :error => "Failed to delete task" }
      end
    else
      redirect_to root_path, status: 302, :flash => { :error => "Could not find task with id: #{params[:id]}" }
    end
  end

  def toggle_complete
    @task = Task.find_by(id: params[:id])

    if @task
      if @task.update task_params
        redirect_to root_path
      else
        redirect_to root_path, :flash => { :error => "Failed to update task" }
      end
    else
      redirect_to root_path, status: 302, :flash => { :error => "Could not find task with id: #{params[:id]}" }
    end
  end

  private

  def task_params
    return params.require(:task).permit(:name, :description, :priority_level, :date_completed)
  end
end
