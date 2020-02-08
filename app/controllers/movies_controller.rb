class MoviesController < ApplicationController

  def movie_params

    params.require(:movie).permit(:title, :rating, :description, :release_date)

  end



  def show

    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default

  end



  def index
  
   change = false
   
   if params[:ratings]
      @m_ratings = params[:ratings]
   elsif session[:ratings]
      @m_ratings = session[:ratings]
      change = true
   else
      @m_ratings = Hash[Movie.all_ratings.map {|x| [x,1]}]
   end
    
   if params[:sorter]
     @m_sorter = params[:sorter]
   elsif session[:sorter]
     @m_sorter = session[:sort]
     change = true
   end
   if change
    flash.keep
    redirect_to movies_path :sorter => @m_sorter, :ratings => @m_ratings
   else
    @movies = Movie.where(:rating=> (@m_ratings ? @m_ratings.keys : session[:ratings].keys)).order(@m_sorter).all
    @all_ratings = Movie.all_ratings
   end
   session[:sorter] = @m_sorter
   session[:ratings] = @m_ratings
  end



  def new

    # default: render 'new' template

  end



  def create

    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path

  end



  def edit

    @movie = Movie.find params[:id]

  end



  def update

    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)

  end



  def destroy

    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path

  end



end