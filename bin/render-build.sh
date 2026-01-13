set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:prepare
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:schema:load
