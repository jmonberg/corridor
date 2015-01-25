require "RMagick"

class CompositeImage
  
  def initialize(images, filename)
    @filename = filename
    @images = Magick::ImageList.new
    for image in images
      @images.read(image.photo.path(:big))
    end
    @images.each {|image| image.resize_to_fill!(160, 160)} 
  end
  
  
  def create_tall_image
    File.open(@filename, "w") do |f|
      @images.append(true).write(f)
    end 
  end
end