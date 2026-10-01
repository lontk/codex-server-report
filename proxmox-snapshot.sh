#!/bin/bash

echo "Доступні LXC-контейнери:"
echo
pct list
echo

read -p "Введи ID контейнера: " CTID

if ! pct status "$CTID" >/dev/null 2>&1; then
    echo "Помилка: контейнер $CTID не знайдено."
    exit 1
fi

DEFAULT_SNAP="manual-$(date +%Y%m%d-%H%M)"
read -p "Назва snapshot [$DEFAULT_SNAP]: " SNAP
SNAP=${SNAP:-$DEFAULT_SNAP}

STATUS=$(pct status "$CTID" | awk '{print $2}')

if [ "$STATUS" = "running" ]; then
    echo "Зупиняю CT $CTID..."
    pct stop "$CTID" || exit 1
fi

echo "Створюю snapshot: $SNAP"
if pct snapshot "$CTID" "$SNAP"; then
    echo "Snapshot створено успішно."
else
    echo "Помилка створення snapshot."

    if [ "$STATUS" = "running" ]; then
        echo "Повертаю контейнер у запущений стан..."
        pct start "$CTID"
    fi

    exit 1
fi

if [ "$STATUS" = "running" ]; then
    echo "Запускаю CT $CTID..."
    pct start "$CTID"
fi

echo
echo "Готово."
pct status "$CTID"
