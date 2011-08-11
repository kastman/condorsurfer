require 'rubygems'
require 'sinatra'
require 'config/boot'

helpers do
  def tab_content(active_tab, tab)
    active_tab == tab ? "<p>#{tab}</p>" : "<a href='/#{tab}'>#{tab}</a>"
  end
  
  include Sinatra::OutputBuffer::Helpers
end

before do
  @app_name         = APP_NAME
  @data_sources_dir = DATA_SOURCES_DIR
  @segments_dir     = SEGMENTS_DIR
end


get %r{/$|/home$} do
  @active_tab = :home
  @data_ids = Dir.directories(@data_sources_dir).sort
  @segments = Dir.directories(@segments_dir).sort
  erb :index
end

get '/segments' do
  @active_tab = :segments
  @segments = Dir.directories(@segments_dir).sort.collect{ |dir| Scarcity::Segment.new(File.join(@segments_dir, dir))}
  erb :segments
end

get '/segments/:segment' do
  @active_tab = :segments
  @segment = Scarcity::Segment.new("#{@segments_dir}/#{params[:segment]}")
  erb :segment
end

get '/segments/:segment/:dataset' do
  @active_tab = :segements
  @segment = Scarcity::Segment.new("#{@segments_dir}/#{params[:segment]}")
  @dataset = @segment.datasets.select {|d| d.data_id == params[:dataset]}.first
  erb :dataset
end

get '/data' do
  @active_tab = :data
  @data_ids = Dir.directories(@data_sources_dir).sort
  erb :data
end

get '/documentation' do
  @active_tab = :documentation
  erb :documentation
end

get '/configuration' do
  @active_tab = :configuration
  erb :configuration
end
