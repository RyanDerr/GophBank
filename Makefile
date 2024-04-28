.PHONY: go_test sqlc_generate docker_start docker_stop

docker_start:
	docker compose up -d

docker_stop:
	docker compose down

sqlc_generate:
	sqlc -f ./bank-service/sqlc.yaml generate

go_test: docker_start
	cd bank-service && go test -v -cover ./...