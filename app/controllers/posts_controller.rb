class PostsController < ApplicationController
  include Pageable
  include Sortable
  include Filterable

  def index
    posts = Post.all

    if params[:filter]
      posts = filter_results(posts, :category, params[:filter])
    end

    if params[:sort]
      sorts = params[:sort].split(',')
      posts = sort_results(posts, *sorts)
    end

    posts = posts.page(page_number)
    render json: posts, meta: pagination_meta(posts), include: ['user']
  end
end
