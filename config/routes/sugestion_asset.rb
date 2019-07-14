resources :sugestion_assets do
	member do
    	put :flag
		put :unflag
		get :share
  	end
end

get 'sugestion_assets/:id/json_data', action: :json_data, controller: 'sugestion_assets'
