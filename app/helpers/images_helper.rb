module ImagesHelper
  def prepare_for_javascript(image)
    "imageurls.push([\"#{image.photo.url(:big) }\", \"#{image_path(image)}\", \"#{image.title}\"])"
  end
end
