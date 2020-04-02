#!/bin/sh
systemctl --user import-environment
exec systemctl --user start sway.service
