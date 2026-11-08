ENGINE_DIR := $(CURDIR)/infra/engine
SRC_DIR := $(CURDIR)/src
BUILD_DIR := $(CURDIR)/build
EXPORT_DIR := $(BUILD_DIR)/export
QR_DIR := $(BUILD_DIR)/qrcodes

export TEXINPUTS := .:$(SRC_DIR)//:$(ENGINE_DIR)/src//:$(CURDIR)/fig//:$(BUILD_DIR)//:
export LUAINPUTS := .:$(SRC_DIR)//:$(ENGINE_DIR)/src//:
export LUA_PATH := $(ENGINE_DIR)/src/?.lua;;
export CG_EXPORT_DIR := $(EXPORT_DIR)
export CG_QR_DIR := $(QR_DIR)

PYTHON_BIN := $(shell if [ -f ./env/bin/python ]; then echo "./env/bin/python"; elif [ -f ../climbing-guide/scripts/python/.venv/bin/python ]; then echo "../climbing-guide/scripts/python/.venv/bin/python"; else echo "python3"; fi)

all: build

.PHONY: all init-dirs build validate check-assets clean

check-assets:
	@$(PYTHON_BIN) scripts/check_assets.py

init-dirs:
	@mkdir -p $(BUILD_DIR) $(EXPORT_DIR) $(QR_DIR)

build: init-dirs check-assets
	@$(PYTHON_BIN) scripts/write_edition.py --out $(BUILD_DIR)
	@echo "Pass 1 - Data Extraction"
	@lualatex --interaction=batchmode --halt-on-error --output-directory=$(BUILD_DIR) src/main.tex
	@echo "Generating QR Codes"
	@$(PYTHON_BIN) $(ENGINE_DIR)/scripts/python/generate_qrcodes.py --manifest $(EXPORT_DIR)/qrcodes_manifest.json --outdir $(QR_DIR)
	@echo "Pass 2 - Layout"
	@lualatex --interaction=batchmode --halt-on-error --output-directory=$(BUILD_DIR) src/main.tex
	@echo "Pass 3 - TikZ"
	@lualatex --interaction=batchmode --halt-on-error --output-directory=$(BUILD_DIR) src/main.tex
	@mv $(BUILD_DIR)/main.pdf $(BUILD_DIR)/serra_do_cuo.pdf

validate:
	@$(PYTHON_BIN) scripts/check_assets.py --pdf $(BUILD_DIR)/serra_do_cuo.pdf
	@echo "Validating logs..."
	@bash $(ENGINE_DIR)/scripts/parse_logs.sh $(BUILD_DIR)/main.log
	@echo "Validating fonts..."
	@bash $(ENGINE_DIR)/scripts/check_fonts.sh $(BUILD_DIR)/system_fonts.log
	@echo "Validating exports..."
	@bash $(ENGINE_DIR)/scripts/validate_exports.sh $(EXPORT_DIR)
	@test -s $(EXPORT_DIR)/list_alpha.txt && test -s $(EXPORT_DIR)/list_grade.txt

clean:
	@rm -rf $(BUILD_DIR)
