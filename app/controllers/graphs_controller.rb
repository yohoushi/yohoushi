class GraphsController < ApplicationController
  include Util
  before_action :set_root
  before_action :set_graph, only: [:view_graph, :setup_graph]
  before_action :set_graphs, only: [:list_graph, :tag_graph]
  before_action :set_graph_parameter, only: [:view_graph, :list_graph, :tag_graph]
  before_action :path_redirect, only: [:tree_graph, :view_graph, :list_graph]
  before_action :tag_redirect, :set_tags, only: [:tag_graph]
  before_action :autocomplete_search, only: [:autocomplete_graph]
  before_action :tagselect_search, only: [:tagselect_graph]
  before_action :set_children, only: [:accordion_graph]

  # GET /tree_graph
  def tree_graph
  end

  # GET /list_graph
  def list_graph
  end

  # GET /view_graph
  def view_graph
  end

  # GET /setup_graph
  def setup_graph
  end

  # GET /tag_graph
  def tag_graph
    @tab = 'tag'
    render action: 'list_graph'
  end

  # GET /autocomplete_graph?term=xxx for ajax autocomplete
  def autocomplete_graph
    render :json => @autocomplete.map {|node|
      description = node.description.present? ? " (#{node.description})" : ""
      {label: "#{node.path}#{description}", value: node.path}
    }
  end

  # GET /tagselect_graph?term=xxx for ajax tag autocomplete
  def tagselect_graph
    render :json => @tagselect.map(&:name)
  end

  # GET /accordion_graph?path=xxx for ajax accordion navigation
  def accordion_graph
    render :json => @children.map {|c| 
      uri = c.graph? ? view_graph_path(path: c.path) : list_graph_path(path: c.path)
      {:uri => uri, :path => c.path, :basename => c.basename, :has_children => c.has_children?}
    }
  end

  private

  def set_graph_parameter
   if params.has_key?('size')
      params["action"] == "view_graph" ?
        params['view_size'] = params['size'] :
        params['list_size'] = params['size']
    end

    # restore from session
    @graph_parameter = session[:graph_parameter] || GraphParameter.new
    # override with query parameters
    @graph_parameter.update(params)
    # store into session even if it has an error
    session[:graph_parameter] = @graph_parameter
    flash.now[:alert] = @graph_parameter.decorate.view_errors
  end

  def tag_redirect
    return unless (tag_list = request.query_parameters[:tag_list])
    redirect_to "#{tag_graph_root_path}/#{URI.escape(tag_list)}"
  end

  def path_redirect
    return unless (path = request.query_parameters[:path])
    not_found unless (node = Node.find_by(path: path))
    if node.root?
      redirect_to tree_graph_path
    elsif node.has_children?
      redirect_to list_graph_path(path)
    else
      redirect_to view_graph_path(path)
    end
  end

  def set_root
    if params[:path].present?
      @root = Node.where(path: params[:path]).first
    else
      @root = Node.roots.first
    end
  end

  def tagselect_search
    if params[:term]
      term = params[:term].gsub(/ /, '%')
      @tagselect = Tag.select(:name).where("name LIKE ?", "#{term}%") # "%#{term}%")  
    else
      @tagselect = Tag.select(:name).all
    end
    limit = Settings.try(:autocomplete).try(:limit) || 20
    @tagselect = @tagselect.order('name ASC').limit(limit)
  end

  def autocomplete_search
    if params[:term]
      term = params[:term].gsub(/ /, '%')
      @autocomplete = Node.select(:path, :description).where("path LIKE ?", "%#{term}%")
    else
      @autocomplete = Node.select(:path, :description).all
    end
    limit = Settings.try(:autocomplete).try(:limit) || 20
    @autocomplete = @autocomplete.without_roots.visible.order('path ASC').limit(limit)
  end

  def set_tags
    report_time(logger) do
      if params[:tag_list].present?
        set_graphs # utilize ActiveRecord cache
        @tags = @graphs.tag_counts_on(:tags)
        tags_size = @graphs.tags_on(:tags).size
      else
        @tags = Graph.tag_counts_on(:tags)
        tags_size = Tag.all.size # I did not like to post the above big query just for count(*). This was faster
      end

      limit = params[:limit].try(:to_i) || Settings.try(:tagcloud).try(:limit) || 400
      if limit > 0 # limit == 0 if param[:limit] is non-integer string such as "null"
        @tags_has_more = tags_size > limit
        @tags = @tags.order('count DESC').limit(limit)
      end
      @tags = @tags.order('name ASC')
    end
  end

  def set_graphs
    case
    when params[:tag_list].present?
      @graphs = Graph.tagged_with(params[:tag_list].split(',')).visible.order('path ASC')
    when params[:path].present?
      @graphs = Graph.where("path LIKE ?", "#{params[:path]}/%").visible.order('path ASC')
    else
      @graphs = []
    end
    if @graphs.present?
      @graphs = @graphs.page(params[:page]).per(params[:per])
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_graph
    @graph = Graph.find_by(path: params[:path])
    not_found unless @graph
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_params
    params.require(:graph).permit(:path, :description, :tag_list)
  end

  def set_children
    @children = Section.find_by_path(params[:path]).try(:children).try(:visible).try(:order, 'path ASC, type DESC')
    not_found unless @children
  end

end
