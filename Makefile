.PHONY: install build serve clean test

# Default target
all: install build

# Install dependencies
install:
	bundle install

# Build the site
build:
	bundle exec jekyll build

# Serve the site locally
serve:
	bundle exec jekyll serve --livereload

# Clean the site
clean:
	bundle exec jekyll clean
	rm -rf _site

# Test the site
test:
	bundle exec htmlproofer ./_site --allow-missing-href true --allow-hash-href true

# Help target
help:
	@echo "Available commands:"
	@echo "  make install  - Install dependencies"
	@echo "  make build    - Build the site"
	@echo "  make serve    - Serve the site locally with live reload"
	@echo "  make clean    - Clean the site"
	@echo "  make test     - Test the site with htmlproofer"
	@echo "  make help     - Show this help message" 