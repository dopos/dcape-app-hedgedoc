## dcape-app-template Makefile
## This file extends Makefile.app from dcape
#:

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

#- App name
APP_NAME           ?= hedgedoc

#- Docker image name
IMAGE              ?= quay.io/hedgedoc/hedgedoc

#- Docker image tag
IMAGE_VER          ?= latest

#- app root
APP_ROOT           ?= $(PWD)

# If you need database, uncomment this var
USE_DB              = yes

# ------------------------------------------------------------------------------

# if exists - load old values
-include $(CFG_BAK)
export

-include $(CFG)
export

# This content will be added to .env
# define CONFIG_CUSTOM
# # ------------------------------------------------------------------------------
# # Sample config for .env
# #SOME_VAR=value
#
# endef

# ------------------------------------------------------------------------------
# Find and include DCAPE_ROOT/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_ROOT      ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
else
  include /opt/dcape/Makefile.app
endif

# ------------------------------------------------------------------------------

## create user with EMAIL
user-add:
	docker exec -it $(APP_TAG)-app-1 /hedgedoc/bin/manage_users --add $$EMAIL

## delete user with EMAIL
user-del:
	docker exec -it $(APP_TAG)-app-1 /hedgedoc/bin/manage_users --del $$EMAIL

## change password for user with EMAIL
user-psw:
	docker exec -it $(APP_TAG)-app-1 /hedgedoc/bin/manage_users --reset $$EMAIL
