# file: app.rb
require "sinatra"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/album_repository"
require_relative "lib/artist_repository"

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload "lib/album_repository"
    also_reload "lib/artist_repository"
  end

  post "/albums" do
    repo = AlbumRepository.new()
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return ""
  end

  get "/albums" do
    repo = AlbumRepository.new()
    all_albums = repo.all
    response = all_albums.map do |album| album.title 
    end.join(", ")
    return response
  end

  get "/albumslist/:id" do
    repo = AlbumRepository.new()
    artist_repo = ArtistRepository.new()
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album)
  end

  get "/allalbums" do
    repo = AlbumRepository.new 
    @albums = repo.all
    return erb(:allalbums)
  end

  get "/artists/:id" do
    artist_repo = ArtistRepository.new()
    album_repo = AlbumRepository.new()
    @artist = artist_repo.find(params[:id])
    @artists_albums = album_repo.find_by_artist(params[:id]) 
    return erb(:artists)
  end

  get "/artists" do
    artist_repo = ArtistRepository.new()
    @artists = artist_repo.all
    return erb(:all_artists)
  end

  post "/artists" do
    artist_repo = ArtistRepository.new()
     @artist = Artist.new()
     @artist.name = params[:name]
     @artist.genre = params[:genre]
     artist_repo.create(@artist)
     return nil 
  end 
end
