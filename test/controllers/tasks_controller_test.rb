require "test_helper"

describe TasksController do
  # Note to students:  Your Task model **may** be different and
  #   you may need to modify this.
  let (:task) { Task.create name: "sample task", description: "this is an example for a test", priority_level: "low" }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # binding.pry

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do

      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do

      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do

      # Arrange
      # Note to students:  Your Task model **may** be different and
      #   you may need to modify this.
      task_hash = {
        task: {
          name: "A Task",
          description: "A Description of the Task",
          priority_level: "Priority Level",
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])

      # binding.pry

      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.deadline).must_equal task_hash[:task][:deadline]
      expect(new_task.priority_level).must_equal task_hash[:task][:priority_level]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      task = Task.first
      get edit_task_path(task)
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do
      get edit_task_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Could not find task with id: -1"
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      # Arrange
      test_id = Task.last.id
      task_hash = {
        task: {
          name: "updated task",
          description: "updated task description",
          priority_level: "update priority level",
        },
      }

      expect {
        patch task_path(test_id), params: task_hash
      }.wont_change "Task.count"

      updated_task = Task.find_by(name: task_hash[:task][:name])

      expect(updated_task.description).must_equal task_hash[:task][:description]

      must_respond_with :redirect
      must_redirect_to task_path(test_id)
    end

    it "will redirect to the root page if given an invalid id" do

      # Act
      patch task_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Could not find task with id: -1"

      must_redirect_to root_path
    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    it "removes a task from the database" do
      # Act-Assert
      task = Task.create!(name: "Sort socks", description: "Find all the lonely socks a pair.", priority_level: "Low")

      expect {
        delete task_path(task)
      }.must_change "Task.count", -1

      must_respond_with :redirect
      must_redirect_to root_path

      after_task = Task.find_by(id: task.id)
      expect(after_task).must_be_nil
    end
  end

  describe "toggle_complete" do
    it "can mark an incomplete task complete without changing anything else" do
      # Arrange
      test_task = Task.last
      test_task.update date_completed: nil
      initial_attributes = test_task.attributes.clone
      task_hash = {
        task: {
          date_completed: Time.now.to_date,
        },
      }

      #Act-Assert
      expect {
        patch toggle_complete_task_path(test_task.id), params: task_hash
      }.wont_change "Task.count"

      test_task.reload

      expect(test_task.name).must_equal initial_attributes["name"]
      expect(test_task.description).must_equal initial_attributes["description"]
      expect(test_task.date_completed).must_equal task_hash[:task][:date_completed]

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
