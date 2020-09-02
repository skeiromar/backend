class ProductsController < ApplicationController
  # skip_before_action :authorized, only: [:index, :show]
# product.as_json(only: [:id, :price, :title, :description, :category])
  def index
    @products = Product.all
    @serializedProducts = []
    @products.each do |product|
      @serializedProducts.push({
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        imageTray: url_for(product.image_tray[0]),
        reviewCount: product.reviews.length
      }
    )
    end
    render json: @serializedProducts
  end

  def trending_products
    @products = Product.all.includes(:reviews)
    @sorted_products = @products.sort_by{|obj| -obj.reviews.length}
    @trending_products = (0..3).map { |n| @sorted_products[n] }
    @serializedProducts = []
    # byebug
    @trending_products.each do |product|
      @serializedProducts.push({
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        imageTray: url_for(product.image_tray[0]),
        reviewCount: product.reviews.length
      }
    )
    end
    render json: @serializedProducts
  end

  def show
    # product.image_tray.map{|img| url_for(img)}.flatten
    product = Product.find_by(id: params[:id])
    @serializedProduct = {
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      imageTray: product.image_tray.map{|img| url_for(img)}.flatten,
      reviews: product.reviews.map{ |review| {
        id: review.id,
        body: review.body,
        createdAt: review.created_at.strftime("%b %d, %Y"),
        userName: review.user.username,
        userPicture: review.user.picture.attached? ? url_for(review.user.picture) : ''
      }},
      category: product.category
    }
    render json: @serializedProduct
  end

end
