require 'spec_helper'

feature 'Defering a todo to be shown at a later date', js: true do
  let!(:user) { sign_up_for_site(email: 'blah@gmail.com',
                                 username: 'blah12345',
                                 password: 'Password987!') }
  let!(:todo) { user.todos.create!(description: 'Do something') }
  let!(:todo2) { user.todos.create!(description: 'Do something else') }

  scenario 'change a visibility date' do
    logs_in_to_site('blah@gmail.com', 'Password987!')
    defers_todo(todo, num_days: 4)
    todo_should_not_be_visible(todo)
    come_back_another_day
    todo_should_be_visible(todo)
  end

  def sign_up_for_site(options = {})
    username, email, password = options.fetch(:username),
                                options.fetch(:email),
                                options.fetch(:password)
    visit '/'
    click_link('Sign up')
    fill_in 'Username', with: username
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_button 'Sign up'
    click_link 'Logout'
    User.last
  end

  def logs_in_to_site(email, password)
    visit '/'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  def defers_todo(todo, options = {})
    num_days = options.fetch(:num_days)
    click_link '#todo-row-#{todo.id} .defer-link'
    fill_in 'Days to defer', with: num_days
  end

end
