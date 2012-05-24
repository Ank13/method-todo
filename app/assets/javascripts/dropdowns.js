var DropdownsBar = Backbone.View.extend({
  el : '#dropdowns-bar',

  events : {
    'click #all-todos-button-navitem' : 'viewAllTodos'
  },

  initialize : function()
  {
    this.all_button = this.$('#all-todos-button-navitem');
  },

  viewAllTodos : function()
  {
    $('#project-dropdown-navitem a.dropdown-toggle').html('Project');
    $('#context-dropdown-navitem a.dropdown-toggle').html('Context');
    this.$('#all-todos-button-navitem').addClass('active');
    this.$('.dropdown').removeClass('active');
    this.$('.dropdown-menu li').removeClass('active');
    ViewOptions.context_id = null;
    ViewOptions.project_id = null;
    ActiveTodos.redraw();
    CompletedTodos.redraw();
  }
}
);