echo "Setting up dummy Redmine"
git clone https://github.com/edavis10/redmine.git spec/dummy_redmine 
cd spec/dummy_redmine && git co 1.1.3
cp spec/ci_config/database.ci.yml spec/dummy_redmine/config/database.yml  
cd spec/summy/redmine && bundle exec rake db:create db:migrate 
