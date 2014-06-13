class GraphsController < ApplicationController
  include Util
  before_action :set_root
  before_action :set_graph, only: [:view_graph, :setup_graph, :update_graph, :delete_graph]
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

  # DELETE /tag_graph/:tag_list
  def delete_tag_graph
    @tab = 'tag'
    tag_list = params[:tag_list].split(',')
    @graphs = Graph.tagged_with(tag_list)
    @graphs.each do |graph|
      $mfclient.delete_graph(graph.path) rescue nil
    end
    # will not delete the entry in the yohoushi db here, yohoushi worker will delete it
    redirect_to tag_graph_root_path, notice: "Graphs tagged with #{tag_list.to_sentence} will be deleted by worker soon."
  end

  # PATCH/PUT /update_graph
  def update_graph
    begin
      success = ActiveRecord::Base.transaction do
        @graph.update(graph_params)
        # $mfclient.edit_graph(@graph.path, update_params) # @todo
      end
    rescue => e
      @graph.valid?
    end

    if success
      redirect_to @graph.decorate.setup_graph_path, notice: 'Graph was successfully updated.'
    else
      redirect_to @graph.decorate.setup_graph_path, alert: 'Failed to update a graph.'
    end
  end

  # DELETE /delete_graph
  def delete_graph
    begin
      success = $mfclient.delete_graph(@graph.path)
      # will not delete the entry in the yohoushi db here, yohoushi worker will delete it
    rescue => e
    end

    if success
      redirect_to @graph.parent.decorate.list_graph_path, notice: 'Graph was successfully deleted. Please wait for a while until the graph will be completely deleted.'
    else
      redirect_to @graph.decorate.setup_graph_path, alert: 'Failed to delete a graph.'
    end
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
      uri = c.decorate.graph_path
      {:uri => uri, :path => c.path, :basename => c.basename, :has_children => c.has_children?}
    }
  end

  private

  def set_graph_parameter
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
    tag_list = URI::escape(tag_list) # query_parameters unescapes, so escape
    redirect_to @root.decorate.tag_graph_path(tag_list)
  end

  def path_redirect
    return unless (path = request.query_parameters[:path])
    not_found unless (node = Node.find_by(path: path))
    redirect_to node.decorate.graph_path
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
      @tags = @tags.order('name ASC')
      if limit > 0 # limit == 0 if param[:limit] is non-integer string such as "null"
        @tags_has_more = tags_size > limit
        @tags = @tags.limit(limit)
      end
      @tags
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
      params[:per] ||= Kaminari.config.default_per_page # to show &per= parameter on linked url as default
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
    params.require(:graph).permit(:path, :description, :tag_list, :visible)
  end

  def set_children
    @children = Section.find_by_path(params[:path]).try(:children).try(:visible).try(:order, 'path ASC, type DESC')
    not_found unless @children
  end

end
