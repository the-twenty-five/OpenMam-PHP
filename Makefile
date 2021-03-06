init:
	@bin/console_api do:da:cr # Initialize database
	@bin/console_api do:sc:up --force # Generate schema for refresh_token

install:
	docker build docker/application
	docker-compose run --rm composer install
	docker-compose run --rm application npm install

start: install
	docker-compose up -d
	@echo ''
	@echo ''
	@echo  'The application => http://127.0.0.1:7000/app_dev.php'
	@echo ''
	@docker-compose run --rm application rm -rf ../var/cache
	@docker-compose run --rm application rm -rf ../var/logs

stop:
	docker-compose stop

test:
	@docker-compose run --rm application ../bin/console_api do:da:cr -e=test # Initialize database for test
	@docker-compose run --rm application ../bin/console_api do:sc:up -e=test --force # Generate schema for refresh_token for test
	@docker-compose run --rm application ../vendor/bin/phpunit ../tests/
