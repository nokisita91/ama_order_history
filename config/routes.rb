Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'ama_order_history#index'
  get 'index' => 'ama_order_history#index'
  get "collect" => "ama_order_history#collect"
  get "collected" => "ama_order_history#collected"
  get "delete" => "ama_order_history#delete"
  get "excel_trans_failed" => "ama_order_history#excel_trans_failed"
  get "excel_trans_succeeded" => "ama_order_history#excel_trans_succeeded"
  get "excel_trans" => "ama_order_history#excel_trans"
  get "nocollected" => "ama_order_history#nocollected"
  get "nodeleted" => "ama_order_history#nodeleted"
  get "report" => "ama_order_history#report"
  get "list" => "ama_order_history#list"
  post "collect_post" => "ama_order_history#collect_post"
  post "collect_DL" =>  "ama_order_history#collect_DL"
  get "test" => "ama_order_history#test"
  get "test2" => "ama_order_history#test2"
  
end
