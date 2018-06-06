Rails.application.routes.draw do
  get "/replays" => "replays#index"
  get "/popular" => "stats#popular"

  get ":path" => "home#index"
  root to: "home#index"
end
