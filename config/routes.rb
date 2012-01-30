ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'time_balances', :action => 'index' do |routes|
    routes.connect '/projects/:project_id/time_balances'
  end
end