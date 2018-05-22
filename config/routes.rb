Rails.application.routes.draw do
  # see http://guides.rubyonrails.org/routing.html
  get "/replays" => "replays#index"

  root to: "home#index"
end
