#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Proxy Configuration Script
# ═══════════════════════════════════════════════════════════════
# This script sets up proxy settings for the system

# Proxy configuration
export HTTP_PROXY="http://10.36.255.25:8080"
export HTTPS_PROXY="http://10.36.255.25:8080"
export FTP_PROXY="http://10.36.255.25:8080"
export NO_PROXY="localhost,127.0.0.1,::1,10.*,192.168.*"

# Lowercase variants (some applications use these)
export http_proxy="$HTTP_PROXY"
export https_proxy="$HTTPS_PROXY"
export ftp_proxy="$FTP_PROXY"
export no_proxy="$NO_PROXY"

