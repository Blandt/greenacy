# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
####Frontend Css
Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( bootstrap-theme.css )
Rails.application.config.assets.precompile += %w( font-awesome.min.css )
Rails.application.config.assets.precompile += %w( jquery.bxslider.css )
####Frontend Js
Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
Rails.application.config.assets.precompile += %w( jquery.bxslider.js )

####Admin Css
Rails.application.config.assets.precompile += %w( control_panel/iCheck/skins/minimal/minimal.css )
Rails.application.config.assets.precompile += %w( control_panel/iCheck/skins/square/square.css )
Rails.application.config.assets.precompile += %w( control_panel/iCheck/skins/square/red.css )
Rails.application.config.assets.precompile += %w( control_panel/iCheck/skins/square/blue.css )
Rails.application.config.assets.precompile += %w( control_panel/clndr.css )
Rails.application.config.assets.precompile += %w( control_panel/morris-chart/morris.css )
Rails.application.config.assets.precompile += %w( control_panel/style.css )
Rails.application.config.assets.precompile += %w( control_panel/style-responsive.css )


####Admin Js
Rails.application.config.assets.precompile += %w( control_panel/jquery-1.10.2.min.js )
Rails.application.config.assets.precompile += %w( control_panel/jquery-ui-1.9.2.custom.min.js )
Rails.application.config.assets.precompile += %w( control_panel/jquery-migrate-1.2.1.min.js )
Rails.application.config.assets.precompile += %w( control_panel/bootstrap.min.js )
Rails.application.config.assets.precompile += %w( control_panel/modernizr.min.js )
Rails.application.config.assets.precompile += %w( control_panel/jquery.nicescroll.js )
Rails.application.config.assets.precompile += %w( control_panel/scripts.js )