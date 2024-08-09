# Default quality for PNG conversion
QUALITY := 512

# Check if the file parameter is provided
SVG_FILE := $(word 2, $(MAKECMDGOALS))

# The default target, which will be executed when you run `make`
all: help

# Target to convert SVG to PNG
convert:
	@if [ -z "$(SVG_FILE)" ]; then \
		echo "Error: You must specify a file. Usage: make convert -- <file>"; \
		exit 1; \
	fi
	inkscape -w $(QUALITY) -h $(QUALITY) "src/$(SVG_FILE).svg" -o "png/$(SVG_FILE).png"

# Help target to show usage information
help:
	@echo "Usage:"
	@echo "  make convert -- <file>  Convert the specified SVG file to PNG with default quality."
	@echo "  make clean              Remove the generated PNG file."
	@echo ""
	@echo "Variables:"
	@echo "  QUALITY=<value>         Set the quality (width and height) for the PNG output."

# Clean up any generated PNG files
clean:
	rm -f *.png

# Prevent make from thinking that the parameters are targets
%:
	@:
