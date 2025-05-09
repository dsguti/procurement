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

unzip-csv:
    # mkdir data/intermediate/tenders
    unzip 'data/raw/chile/tenders/*.zip' -d data/intermediate/tenders/
    unzip 'data/raw/chile/purchases/*.zip' -d data/intermediate/purchases/

convert-encoding: convert-encoding-tenders convert-encoding-purchases

convert-encoding-tenders:
    #!/usr/bin/env bash
    for file in data/intermediate/tenders/*; do
        echo "$file"
        iconv -f "ISO-8859-1" -t "UTF-8" "$file" > "$file.converted"
        mv -f "$file.converted" "$file"
        #file -i "$f"
    done

convert-encoding-purchases:
    #!/usr/bin/env bash
    for file in data/intermediate/purchases/*; do
        echo "$file"
        iconv -f "ISO-8859-1" -t "UTF-8" "$file" > "$file.converted"
        mv -f "$file.converted" "$file"
        #file -i "$f"
    done

database-init-tenders:
    duckdb data/processed/tenders.duckdb < build/create-tenders.sql


database-init-purchases:
    duckdb data/processed/purchases.duckdb < build/create-purchases.sql

database-clean-regions-communes:
    duckdb data/processed/purchases.duckdb < build/clean-regions-communes.sql