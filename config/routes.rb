Karstat::Application.routes.draw do
  get ":code" => "subjects#show", :as => :grade
end
