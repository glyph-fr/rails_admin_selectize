RailsAdminSelectize::Engine.routes.draw do
  get 'search/:parent_model_name/:field_name/:parent_action' => 'search#index'
end
