#!/bin/bash

read -p "Введи ID контейнера: " CTID
read -p "Назва snapshot [manual-$(date +%Y%m%d-%H%M)]: " SNAP

SNAP=${SNAP:-manual-$(date +%Y%m%d-%H%M)}

echo "Зупиняю CT $CTID..."
pct stop "$CTID"

echo "Створюю snapshot: $SNAP"
pct snapshot "$CTID" "$SNAP"

echo "Запускаю CT $CTID..."
pct start "$CTID"

echo "Готово."
pct status "$CTID"
