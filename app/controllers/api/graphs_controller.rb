module Api
  class GraphsController < ApplicationController
    # before_action :set_graph, only: [:show, :edit, :update, :destroy]

    # GET /graphs
    def index
      @graphs = $mfclient.list_graph
    end

    # GET /graphs/:fullpath
    def show
      @graph = $mfclient.get_graph(params[:fullpath])
    end

    # POST /graphs/:fullpath
    def create
      @graph = $mfclient.post_graph(params[:fullpath], create_params)
      render action: 'show', status: :created
    end

    # PUT /graphs/:fullpath
    def update
      @graph = $mfclient.edit_graph(params[:fullpath], update_params)
      render action: 'show', status: :updated
    end

    # DELETE /graphs/:fullpath
    def destroy
      @graph = $mfclient.delete_graph(params[:fullpath])
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
