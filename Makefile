# SOURCE := $(shell git rev-parse --show-toplevel)
SOURCE := 
include $(SOURCE)scripts/make/build.mk
include $(SOURCE)scripts/make/dev.mk
include $(SOURCE)scripts/make/test.mk
