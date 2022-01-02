#!/usr/bin/bash

# apt install inotify-tools

PROCESS_NAME=AppName

timestamp() {
    date +"%s"
}

LAST_TS=$(timestamp)

inotifywait -r \
    -m \
    --excludei '\.(gitignore)$' \
    --event modify \
    --event delete \
    app_helpers \
    controllers \
    filters \
    models \
    plugins \
    test \
    | while read base event file
    do
        echo $base $event $file

        NOW_TS=$(timestamp)

        if [ $(( $LAST_TS - $NOW_TS )) -eq 0 ]; then
            continue
        fi

        LAST_TS=$(timestamp)

        if [[ ${file} =~ .*\.(hpp|h|cc|cpp)$ ]]; then
            pkill ${PROCESS_NAME}
            make start &
        fi
    done
