#
# * @class MethodTodo.Collections.Tags
# * Represents a collection of Tags
# * @extends Backbone.View
#
MethodTodo.Collections.Tags = Backbone.Collection.extend(

  #
  #   * @cfg
  #   * Associated model
  #
  model: MethodTodo.Models.Tag

  #
  #   * @cfg
  #   * Resource URL to use
  #
  url: "/tags"
)
