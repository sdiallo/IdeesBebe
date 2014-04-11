# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave
  include CarrierWave::MiniMagick

  def default_url
    ActionController::Base.helpers.asset_path(["#{model.class.name.downcase}", version_name, "default.png"].compact.join('_'))
  end
 
  before :store, :remember_cache_id
  after :store, :delete_tmp_dir

  process :resize_to_fill => [200,200]

  version :thumb do
    process :resize_to_fill => [100,100]
  end
  version :edit_thumb do
    process :resize_to_fill => [250,210]
  end

  # store! nil's the cache_id after it finishes so we need to remember it for deletion
  def remember_cache_id(new_file)
    @cache_id_was = cache_id
  end
  
  def delete_tmp_dir(new_file)
    # make sure we don't delete other things accidentally by checking the name pattern
    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      FileUtils.rm_rf(cache_dir)
    end
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
