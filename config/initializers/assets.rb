# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( cssreset.css )

%w( home user sessions applications admin).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js", "#{controller}.css"]
end

# Precompile select2
Rails.application.config.assets.precompile += %w( select2.min.js select2.css )
Rails.application.config.assets.precompile += %w( sponsorship.js statistics.js )
Rails.application.config.assets.precompile += %w( d3.min.js jqcloud.min.js)
