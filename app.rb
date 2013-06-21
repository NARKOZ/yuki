require 'mkmf'
require 'slim'
require 'sinatra/base'
require 'carrierwave/sequel'

FFMPEG_EXECUTABLE = find_executable 'ffmpeg'
PUBLIC_DIR = File.expand_path '../public', __FILE__

CarrierWave.configure do |config|
  config.root = PUBLIC_DIR
end

DB = Sequel.connect('sqlite://yuki.db')

DB.create_table? :uploads do
  primary_key :id
  String :video
  String :image
end

class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "#{PUBLIC_DIR}/uploads/file/#{model.id}"
  end

  def extensions_white_list
    ['mp4']
  end
end

class Upload < Sequel::Model
  mount_uploader :video, FileUploader
  mount_uploader :image, FileUploader
end

class Yuki < Sinatra::Base
  Slim::Engine.set_default_options format: :html5

  configure :development do
    Slim::Engine.set_default_options pretty: true

    require 'better_errors'
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__

    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  get '/' do
    @page_title = 'Uploads'
    @uploads = Upload.all
    slim :index
  end

  post '/' do
    upload = Upload.new
    upload.video = params[:data]
    unless FFMPEG_EXECUTABLE.nil?
      upload.image = File.open convert_to_gif(upload.video)
    end
    upload.save
    redirect '/'
  end

  def convert_to_gif(movie_file)
    raise 'ffmpeg not found in PATH. Please install FFmpeg' if FFMPEG_EXECUTABLE.nil?

    filename   = movie_file.file.filename.chomp('.mp4')
    upload_dir = movie_file.path.chomp movie_file.file.filename
    gif_image  = "#{upload_dir}/#{filename}.gif"

    `#{FFMPEG_EXECUTABLE} -i "#{movie_file.path}" -pix_fmt rgb24 -r 4 "#{gif_image}"`
    gif_image
  end
end
