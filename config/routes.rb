Karstat::Application.routes.draw do
  get ":code" => "courses#show", :as => :grade
end
