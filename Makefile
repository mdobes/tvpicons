# Default quality for PNG conversion
QUALITY := 512

# Directories
SRC_DIR := src
PNG_DIR := png

# Check if the file parameter is provided
SVG_FILE := $(word 2, $(MAKECMDGOALS))

# File mapping channel keys to display names
DISPLAYNAME_FILE := displayname.yml

.PHONY: all convert displaynames check-displaynames help clean

# The default target, which will be executed when you run `make`
all: help

# Target to convert SVG to PNG
convert:
	@if [ -z "$(SVG_FILE)" ]; then \
		echo "Error: You must specify a file. Usage: make convert -- <file>"; \
		exit 1; \
	fi
	@if [ ! -f "$(SRC_DIR)/$(SVG_FILE).svg" ]; then \
		echo "Error: $(SRC_DIR)/$(SVG_FILE).svg does not exist."; \
		exit 1; \
	fi
	@mkdir -p "$(PNG_DIR)"
	inkscape -w $(QUALITY) -h $(QUALITY) "$(SRC_DIR)/$(SVG_FILE).svg" -o "$(PNG_DIR)/$(SVG_FILE).png"

# Target to sync displayname.yml with src/*.svg:
#   - remove entries whose SVG no longer exists
#   - append missing SVGs (with empty value) at the end
displaynames:
	@tmp="$(DISPLAYNAME_FILE).tmp"; added=0; removed=0; \
	: > "$$tmp"; \
	while IFS= read -r line || [ -n "$$line" ]; do \
		[ -z "$$line" ] && continue; \
		key=$${line#-}; key=$${key%%:*}; \
		if [ -f "$(SRC_DIR)/$$key.svg" ]; then \
			printf '%s\n' "$$line" >> "$$tmp"; \
		else \
			echo "- removed: $$key"; \
			removed=$$((removed + 1)); \
		fi; \
	done < "$(DISPLAYNAME_FILE)"; \
	mv "$$tmp" "$(DISPLAYNAME_FILE)"; \
	for svg in $(SRC_DIR)/*.svg; do \
		key=$$(basename "$$svg" .svg); \
		if ! grep -q "^-$$key:" "$(DISPLAYNAME_FILE)" 2>/dev/null; then \
			echo "-$$key:" >> "$(DISPLAYNAME_FILE)"; \
			echo "+ added: $$key"; \
			added=$$((added + 1)); \
		fi; \
	done; \
	echo "Done. Added $$added, removed $$removed."

# Target to check displayname.yml: empty values, duplicate keys, and svg <-> yaml mismatches
check-displaynames:
	@status=0; \
	echo "== Entries with empty value =="; \
	if grep -nE "^-[^:]+:[[:space:]]*$$" "$(DISPLAYNAME_FILE)"; then status=1; else echo "  (none)"; fi; \
	echo "== Duplicate keys =="; \
	dups=$$(grep -oE "^-[^:]+:" "$(DISPLAYNAME_FILE)" | sort | uniq -d); \
	if [ -n "$$dups" ]; then echo "$$dups"; status=1; else echo "  (none)"; fi; \
	echo "== SVG files missing from $(DISPLAYNAME_FILE) =="; \
	missing=0; \
	for svg in $(SRC_DIR)/*.svg; do \
		key=$$(basename "$$svg" .svg); \
		grep -q "^-$$key:" "$(DISPLAYNAME_FILE)" || { echo "  $$key"; missing=1; status=1; }; \
	done; \
	[ $$missing -eq 0 ] && echo "  (none)"; \
	echo "== Entries in $(DISPLAYNAME_FILE) without an SVG =="; \
	orphan=0; \
	for key in $$(grep -oE "^-[^:]+:" "$(DISPLAYNAME_FILE)" | sed 's/^-//;s/:$$//'); do \
		[ -f "$(SRC_DIR)/$$key.svg" ] || { echo "  $$key"; orphan=1; status=1; }; \
	done; \
	[ $$orphan -eq 0 ] && echo "  (none)"; \
	[ $$status -eq 0 ] && echo "OK: $(DISPLAYNAME_FILE) is consistent." || echo "Problems found (see above)."; \
	exit $$status

# Help target to show usage information
help:
	@echo "Usage:"
	@echo "  make convert -- <file>  Convert the specified SVG file to PNG with default quality."
	@echo "  make displaynames       Add missing $(SRC_DIR)/*.svg entries into $(DISPLAYNAME_FILE)."
	@echo "  make check-displaynames Check $(DISPLAYNAME_FILE) for empty/duplicate/mismatched entries."
	@echo "  make clean              Remove the generated PNG files."
	@echo ""
	@echo "Variables:"
	@echo "  QUALITY=<value>         Set the quality (width and height) for the PNG output."

# Clean up any generated PNG files
clean:
	rm -rf "$(PNG_DIR)"

# Prevent make from thinking that the parameters are targets
%:
	@: