var Todo = Backbone.Model;

var TodoList = Backbone.Collection.extend({
  model : Todo,

  redraw : function()
  {
    this.fetch({url : this.getFilteredUrl()});
  },

  getFilteredUrl : function()
  {
    var parameters = [];

    if(ViewOptions.context_id)
    {
      parameters.push("context_id=" + ViewOptions.context_id);
    }

    if(ViewOptions.project_id)
    {
      parameters.push("project_id=" + ViewOptions.project_id);
    }

    query_string = "";
    if(this.url.charAt(this.url.length - 1) != '?')
    {
      query_string="&";
    }

    if(parameters.length > 0)
    {
      parameters = parameters.join("&");
      query_string += parameters;
    }
    var url = this.url + query_string;

    return this.url + query_string;
  }
}
);

var TodoInput = Backbone.View.extend({
  el : '#add-todo-area',
  events : {
    'submit #new_todo'         : 'createTodo',
    'click #add-todo-button'   : 'createTodo'
  },

  createTodo : function(event)
  {
    event.preventDefault();
    var attributes = {
      todo : {
        description : $('#todo_description').val()
      }
    };
    $('#spinner').spin();
    this.collection.create(
      attributes,
      {
        wait : true,
        success : function()
        {
          $('#todo_description').val('');
          focusTodoInput();
          stopSpinner();
          Contexts.redraw();
          Projects.redraw();
        }
      }
    );
  },

  focus : function()
  {
    $('#todo_description').focus();
  }
});

var TodoTable = Backbone.View.extend({
  events : {
    'click .complete-checkbox' : 'toggleCheckbox',
    'click .todo-badge' : 'clickBadge'
  },

  initialize : function(options)
  {
    this.dropdowns_bar = options.dropdowns_bar;
    this.table_body = this.$el.find('tbody');
    this.template = _.template($('#todo-table-row-template').html());

    this.collection.bind('reset', this.render, this);
    this.collection.bind('add', this.addTodo, this);
  },

  toggleCheckbox : function(event)
  {
    var checkbox = $(event.target);
    var id = parseInt(checkbox.attr('id').replace("todo-complete-", ""));

    var ajaxOptions = {
      type    : 'PUT',
      url     : '/todos/'+id+'/complete',
      data    : {complete : 1},
      complete : function(jqXHR, textStatus)
      {
        stopSpinner();
      }
    };

    $('#spinner').spin();

    if(checkbox.is(':checked'))
    {
      todo = ActiveTodos.find(function(todo) { return todo.id == id });

      ajaxOptions.data = { complete : 1};
      ajaxOptions.success = function(data)
      {
        $('#todo-'+id).addClass('struck-through');
        $('#todo-row-' + id).fadeOut('slow').remove();
        ActiveTodos.remove(todo, {silent : true});
        todo.set('completed', true);
        CompletedTodos.add(todo);
      };
    }
    else
    {
      todo = CompletedTodos.find(function(todo) { return todo.id == id });

      ajaxOptions.data = { complete : 0};
      ajaxOptions.success = function(data)
      {
        $('#todo-row-' + id).fadeOut('slow').remove();
        CompletedTodos.remove(todo, {silent : true});
        todo.set('completed', false);
        ActiveTodos.add(todo);
      };
    }
    $.ajax(ajaxOptions);
  },

  addTodo : function(todo, collection)
  {
    this.table_body.prepend(this.template({todo : todo.attributes}))
  },

  render : function()
  {
    this.table_body.html('');
    var self = this;
    this.collection.each(
      function(todo)
      {
        self.table_body.append(self.template({todo : todo.toJSON()}))
      }
    );
    return this;
  },

  clickBadge : function(event)
  {
    event.preventDefault();
    var badge = $(event.currentTarget);
    var badge_id = _(badge.attr('class').split(/\s+/)).find(function(className) { return className != 'todo-badge' });
    var badge_type = badge_id.match(/(.*)-badge/)[1];
    var id = parseInt(badge_id.replace(badge_type + '-badge-', ''));

    this.dropdowns_bar.selectDropdownItem(id, badge_type, true);

    ActiveTodos.redraw();
    CompletedTodos.redraw();
  }

}
);

ActiveTodos = new TodoList();
ActiveTodos.url= '/todos?';

CompletedTodos = new TodoList();
CompletedTodos.url = '/todos?completed=1';
