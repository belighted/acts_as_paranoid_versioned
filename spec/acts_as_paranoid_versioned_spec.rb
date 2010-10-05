require File.join(File.dirname(__FILE__), 'spec_helper')

class Worker < ActiveRecord::Base
  has_many :tasks
end

class Task < ActiveRecord::Base
  acts_as_paranoid_versioned({:triggered_by => [:state]})
  belongs_to :worker
end

describe :paranoid_versioned do
  describe :acts_as_paranoid_versioned do
    before :each do
      DatabaseCleaner.clean
    end

    it "sets the started_at date when creating a new task" do
      worker = Worker.create(:name => 'R2D2')
      worker.tasks.create(:name => "Follow C3PO")
      worker.tasks.first.started_at.should_not be_nil
      worker.tasks.first.ended_at.should be_nil
    end

    it "sets the ended_at date when destroying a task" do
      worker = Worker.create(:name => 'R2D2')
      task   = worker.tasks.create(:name => "Follow C3PO")
      task.destroy
      task.started_at.should_not be_nil
      task.ended_at.should_not be_nil
    end

    it "creates a new version when a trigger field is updated" do
      worker     = Worker.create(:name => 'R2D2')
      task       = worker.tasks.create(:name => "Follow C3PO", :state => "started")
      Task.class_eval{with_exclusive_scope { find(:all) }}.size.should eql 1
      task.state = "finished"
      task.save!
      Task.class_eval{with_exclusive_scope { find(:all) }}.size.should eql 2
    end

    it "doesn't create a new version when a non triggering field is updated" do
      worker     = Worker.create(:name => 'R2D2')
      task       = worker.tasks.create(:name => "Follow C3PO", :state => "started")
      Task.class_eval{with_exclusive_scope { find(:all) }}.size.should eql 1
      task.name = "Follow ObiWan"
      task.save!
      Task.class_eval{with_exclusive_scope { find(:all) }}.size.should eql 1
    end

    it "doesn't show the ended tasks by default" do
      worker     = Worker.create(:name => 'R2D2')
      task1      = worker.tasks.create(:name => "Follow C3PO", :state => "started")
      task2      = worker.tasks.create(:name => "Poke C3PO", :state => "started")
      worker.tasks.all.size.should eql 2
      task2.destroy
      worker.tasks.all.size.should eql 1
      Task.class_eval{with_exclusive_scope { find(:all) }}.size.should eql 2
    end
  end

  describe :active? do
    it "returns true when there is a start date and no end date" do
      task = Task.create
      task.active?.should be_true
    end

    it "returns false when there is no start date" do
      task = Task.create
      task.started_at = nil
      task.save!
      task.active?.should be_false
    end

    it "returns false when there are a start and end dates" do
      task = Task.create(:ended_at => Time.now)
      task.active?.should be_false
    end
  end

  describe :destroy do
    it "sets the end date and saves the task" do
      task = Task.create
      task.destroy.should be_true
      task.ended_at.should_not be_nil
    end
  end
end