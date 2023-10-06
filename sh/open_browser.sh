#!/usr/bin/env bash
set -Eeu

source "${SH_DIR}/ip_address.sh"

sleep 1

open "http://$(ip_address):${BG_PORT}/decisions_login"
# open "http://$(ip_address):${BG_PORT}/scores?level_password=W8bqPC"
# open "http://$(ip_address):${BG_PORT}/consulting"
