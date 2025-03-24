db := 'data/processed/procurement.duckdb'

default:
    @just --list -u

download: download-chile-tenders download-chile-purchases

download-chile-tenders:
    #!/usr/bin/env bash
    for year in {2007..2024}
    do
        for month in {1..12}
        do
            echo "now donwloading month ${month} year ${year}"
            curl -o data/raw/chile/tenders/${year}-${month}.zip https://transparenciachc.blob.core.windows.net/lic-da/${year}-${month}.zip
        done
    done

download-chile-purchases:
    #!/usr/bin/env bash
    for year in {2007..2024}
    do
        for month in {1..12}
        do
            file="data/raw/chile/purchases/${year}-${month}.zip"

            if [ -f "$file" ]; then
                echo "File ${file} already exists. Skipping download."
            else
                echo "now downloading month ${month} year ${year}"
                curl -o "$file" https://transparenciachc.blob.core.windows.net/oc-da/${year}-${month}.zip
            fi
        done
    done


database-init:
    duckdb {{db}} -f 'build/database-init.sql'