CONTAINER  = mediafile
DOCKER_CMD = docker run -v $(PWD):/app -it --rm $(CONTAINER)
VIRTUALENV_DIR = .venv

.PHONY: build
build:
	docker build -t $(CONTAINER) .

.PHONY: clean
clean:
	find . \! -user $(USER) -exec sudo chown $(USER) {} \;
	rm -rf *.egg-info .tox .pytest_cache .venv
	-docker stop $(CONTAINER)
	-docker rm $(CONTAINER)

.PHONY: shell
shell:
	$(DOCKER_CMD) bash

.PHONY: tox
tox:
	$(DOCKER_CMD) tox

.PHONY: test
test:
	$(DOCKER_CMD) python -m unittest discover .

.PHONY: testpopm
testpopm:
	$(DOCKER_CMD) python -m unittest test.test_mediafile.MP3Test

.PHONY: lint
lint:
	$(DOCKER_CMD) flake8

.PHONY: ipython
ipython:
	$(DOCKER_CMD) ipython

.PHONY: virtualenv
virtualenv:
	virtualenv --python=/usr/bin/python3.7 $(VIRTUALENV_DIR)
	. $(VIRTUALENV_DIR)/bin/activate && \
		pip install -r requirements.txt && \
        pip install -r requirements-dev.txt && \
        pip install .

.PHONY: testpy
testpy:
	$(DOCKER_CMD) python _test.py