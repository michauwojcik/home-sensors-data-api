SHELL := /bin/bash

MAX_LINE_LENGTH := 88

TARGET_PYTHON_VERSION := py313

# 
# DEVELOPMENT
#
.PHONY: install
install:
	@printf ">> Installing dependencise from requirements.txt...\n\n" && \
	pip install -r requirements.txt && \
	printf ">> Installing dependencise from dev-requirements.txt...\n\n" && \
	pip install -r dev-requirements.txt


#
# LINTER & CODE QUALITY
#
.PHONY: lint
lint:
	@printf ">> Checking linting..\n" && \
	flake8 --max-line-length=${MAX_LINE_LENGTH} --ignore D100,D101,D102,D103,D104,D105,D106,D107,D202,D301,D412,E203,W503,N806,N818 tests && \
	flake8 --max-line-length=${MAX_LINE_LENGTH} --ignore D100,D101,D102,D103,D104,D105,D106,D107,D202,D301,D412,E203,W503,N806,N818 dataapi && \
	printf ">> Linting passed! The code is perfect! 🎉\n" || (printf ">> Linting failed! 💥\n" && exit 1)

.PHONY: format
format:  ## sort Python imports & enforce PEP 8 compliant formatting
	@printf ">> Formatting...\n" && \
	isort . && \
	black -t ${TARGET_PYTHON_VERSION} . --extend-exclude="setup_migrations_models\.py"


# 
# RUN APP
#
.PHONY: start_server_debug_mode
start_server_debug_mode:
	source env.sh && \
	export EXTENDED_RESPONSE_BODY=true && \
	export LOG_LEVEL=DEBUG && \
	uvicorn homesensorsdataapi.main:app --reload

