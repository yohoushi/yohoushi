module Api
  class GraphsController < ApplicationController
    # before_action :set_graph, only: [:show, :edit, :update, :destroy]

    # GET /graphs
    def index
      @graphs = $mgclient.list_graph
    end

    # GET /graphs/:path
    def show
      @graph = $mgclient.get_graph(params[:path])
    end

    # POST /graphs/:path
    def create
      @graph = $mgclient.post_graph(params[:path], create_params)
      render action: 'show', status: :created
    end

    # PUT /graphs/:path
    def update
      @graph = $mgclient.edit_graph(params[:path], update_params)
      render action: 'show', status: :updated
    end

    # DELETE /graphs/:path
    def destroy
      @graph = $mgclient.delete_graph(params[:path])
      render action: 'show', status: :no_content
    end

    private

    def create_params
      params.permit(:number)
    end

    def update_params
      params.permit(:llimit, :mode, :stype, :meta, :gmode, :color, :ulimit, :description,
                    :sulimit, :unit, :sort, :adjust, :type, :sllimit)
    end
  end
end
