# Define module directories
MODULES = libs/module1/src libs/module2/src

# Define variables
VENV_DIR = venv
PYTHON = python
REQ_FILE = requirements.txt

# Default target (shows help)
.PHONY: all
all: help

# Help message
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@echo "  create-venv        Create virtual environment and install dependencies"
	@echo "  update-venv        Update virtual environment for all modules"
	@echo "  install-apt        Install system-level apt packages (useful for WSL or Linux)"
	@echo "  clean              Clean up all virtual environments and temporary files"
	@echo "  format             Run black to format all modules"
	@echo "  flake8             Run flake8 linting for all modules"
	@echo "  isort              Run isort for sorting imports"
	@echo "  lint               Run pylint for all modules"
	@echo "  pyright            Run pyright for type checking"
	@echo "  test               Run pytest for all modules"
	@echo "  test-all           Run all tests (format, flake8, isort, lint, pyright, pytest)"
	@echo ""

# Create virtual environment and install dependencies
.PHONY: create-venv
create-venv:
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "Creating virtual environment..."; \
		$(PYTHON) -m venv $(VENV_DIR); \
	fi
	@echo "Activating virtual environment and installing dependencies..."
	@source $(VENV_DIR)/Scripts/activate && pip install -r $(REQ_FILE)

# Update virtual environment by reinstalling packages
.PHONY: update-venv
update-venv:
	@if [ -d "$(VENV_DIR)" ]; then \
		echo "Updating virtual environment..."; \
		source $(VENV_DIR)/Scripts/activate && pip install --upgrade -r $(REQ_FILE); \
	else \
		echo "Virtual environment does not exist. Use 'make create-venv' first."; \
	fi

# Delete the virtual environment
.PHONY: delete-venv
delete-venv:
	@if [ -d "$(VENV_DIR)" ]; then \
		echo "Deleting virtual environment..."; \
		rm -rf $(VENV_DIR); \
	else \
		echo "No virtual environment found to delete."; \
	fi

# Install system-level apt packages (useful for WSL or Linux)
.PHONY: install-apt
install-apt:
	@if [ "$(OS)" = "Windows_NT" ]; then \
		echo "Skipping apt installation; this is a Windows system."; \
	else \
		echo "Installing system dependencies..."; \
		sudo apt-get update && sudo apt-get install -y build-essential libssl-dev tree; \
	fi

# Clean up all virtual environments and temporary files
.PHONY: clean
clean:
	@if [ -d "$(VENV_DIR)" ]; then \
		echo "Deleting virtual environment..."; \
		rm -rf $(VENV_DIR); \
	else \
		echo "No virtual environment found to delete."; \
	fi
	@echo "Cleaning up Python bytecode and temporary files..."
	@rm -rf *.pyc
	@rm -rf __pycache__

# Run black to format all modules
.PHONY: format
format:
	@for module in $(MODULES); do \
		echo "Running black for $$module..."; \
		black $$module; \
	done

# Run flake8 for linting
.PHONY: flake8
flake8:
	@for module in $(MODULES); do \
		echo "Running flake8 for $$module..."; \
		flake8 $$module; \
	done

# Run isort for sorting imports
.PHONY: isort
isort:
	@for module in $(MODULES); do \
		echo "Running isort for $$module..."; \
		isort $$module; \
	done

# Run pylint for all modules
.PHONY: lint
lint:
	@for module in $(MODULES); do \
		echo "Running pylint for $$module..."; \
		pylint $$module; \
	done

# Run pyright for type checking
.PHONY: pyright
pyright:
	@for module in $(MODULES); do \
		echo "Running pyright for $$module..."; \
		pyright $$module; \
	done

# Run pytest for all modules
.PHONY: test
test:
	@for module in $(MODULES); do \
		echo "Running pytest with PYTHONPATH=$$module"; \
		PYTHONPATH=$$module pytest tests; \
	done

# Run all tests (format, flake8, isort, lint, pyright, pytest)
.PHONY: test-all
test-all: format flake8 isort lint pyright test
	@echo "All tests ran successfully!"
