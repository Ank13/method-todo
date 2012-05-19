require 'spec_helper'

describe Todo do
  it "should require a description" do
    Todo.new.should have(1).error_on(:description)
  end

  it ".user should return user" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create(:description => "A New Todo")
    todo.user = user
    todo.save
    todo = Todo.find_by_id todo.id
    todo.user.should == user
  end

  it ".complete should mark record as completed and set completed time" do
    todo = Todo.create(:description => "A New Todo")
    todo.complete
    todo.save
    todo.reload
    todo.completed.should be_true
  end

  it ".uncomplete should mark record as not completed and clear completed time" do
    todo = Todo.create(:description => "A New Todo")
    todo.uncomplete
    todo.save
    todo.reload
    todo.completed.should be_false
  end

  it ".destroy should use Acts as Paranoid to virtually delete the todo" do
    todo = Todo.create(:description => "A New Todo")
    todo.destroy
    Todo.all.should == []
    Todo.only_deleted.should == [todo]
  end

  it ".todo_contexts should return contexts of this todo" do
    todo = Todo.create(:description => "A New Todo")
    todo_context = TodoContext.create(:name => 'home')
    todo.todo_contexts << todo_context
    todo.save
    todo.reload
    todo.todo_contexts.should == [todo_context]
  end

  it ".todo_context should return the first context" do
    todo = Todo.create(:description => "A New Todo")
    todo_context = TodoContext.create(:name => 'home')
    todo.todo_contexts << todo_context
    todo.save
    todo.reload
    todo.todo_context.should == todo_context
  end

  it ".project should return the project" do
    todo = Todo.create(:description => "A New Todo")
    project = Project.create(:name => 'TP Report')
    todo.project = project
    todo.save
    todo.reload
    todo.project.should == project
  end
end

describe Todo, ".parse" do
  it "should add or create a new Project when it detects +" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create :description => 'Write first draft +report'
    todo.user = user
    todo.parse
    todo.project.name.should == 'report'
    todo.save

    todo2 = Todo.create :description => 'Write second draft +report'
    todo2.user = user
    todo2.parse
    todo2.project.should == todo.project
  end

  it "should add or create a new Context when it detects +" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create :description => 'Write first draft @home @coffeeshop'
    todo.user = user
    todo.parse
    todo.todo_contexts.first.name.should == 'home'
    todo.save

    todo2 = Todo.create :description => 'Write second draft @coffeeshop @home'
    todo2.user = user
    todo2.parse
    todo2.save
    todo2.reload
    todo2.todo_contexts.should == todo.todo_contexts
  end

end
