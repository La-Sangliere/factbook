#! /bin/ksh
#! @brief Download the yearly zipped archives from the cia.gov site
#! @usage $0 year   # Download the archive for the provided year
#! @usage $0        # Downloads all archives for years 2000..2020

# https://www.cia.gov/https://www.cia.gov/the-world-factbook/about/archives/2022
# https://www.cia.gov/https://www.cia.gov/the-world-factbook/about/archives/2021

for year in ${1:-{2000..2020}}; do
    /usr/bin/curl -SsLO --user-agent \
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
    https://www.cia.gov/the-world-factbook/about/archives/download/factbook-$year.zip
done

#! @revision 2023-09-16 (Sat) 10:13:21
