#!/bin/env bash

pid=$(pgrep qutebrowser)

if kill -0 $pid 2>/dev/null; then
  qutebrowser :config-source
fi
