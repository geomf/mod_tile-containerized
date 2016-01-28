#!/bin/bash -e
#
# Copyright (c) 2015 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

help() {
    echo -e "\nHelp documentation for update_style"
    echo "Script replaces placeholders in OSMBright/OSMBright.xml style file and get shape files"
    echo "Basic usage: update_style.sh [OPTION] [ARGUMENT]..."
    echo "All options -dhuwp are required"
    echo "-d | --database: database name"
    echo "-h | --hostname: database host address"
    echo "-u | --username: database user name"
    echo "-w | --password: database user password"
    echo -e "-p | --port: database port\n"
    exit 1
}

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -d|--database)
    DATABASE="$2"
    shift # past argument
    ;;
    -h|--hostname)
    HOSTNAME="$2"
    shift # past argument
    ;;
    -u|--username)
    USERNAME="$2"
    shift # past argument
    ;;
    -w|--password)
    PASSWORD="$2"
    shift # past argument
    ;;
    -p|--port)
    PORT="$2"
    shift # past argument
    ;;
    *)
    help
    ;;
esac
shift # past argument or value
done

if [ -z "$DATABASE" ] || [ -z "$HOSTNAME" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$PORT" ]; then
    echo "All parameters -dhuwp are required."
    help
    exit 1
fi

wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
unzip '*.zip'
mkdir ne_10m_populated_places_simple
wget http://naciscdn.org/naturalearth/10m/cultural/ne_10m_populated_places_simple.zip
unzip ne_10m_populated_places_simple.zip -d ne_10m_populated_places_simple/
rm *.zip
mv land-polygons-split-3857 ../mod-tile-docker/shp
mv ne_10m_populated_places_simple ../mod-tile-docker/shp
mv simplified-land-polygons-complete-3857 ../mod-tile-docker/shp

sed -i 's/CDATA\[DBNAME_PLACEHOLDER\]/CDATA\['$DATABASE'\]/g' ../mod-tile-docker/OSMBright/OSMBright.xml
sed -i 's/CDATA\[HOST_PLACEHOLDER\]/CDATA\['$HOSTNAME'\]/g' ../mod-tile-docker/OSMBright/OSMBright.xml
sed -i 's/CDATA\[PASSWORD_PLACEHOLDER\]/CDATA\['$PASSWORD'\]/g' ../mod-tile-docker/OSMBright/OSMBright.xml
sed -i 's/CDATA\[PORT_PLACEHOLDER\]/CDATA\['$PORT'\]/g' ../mod-tile-docker/OSMBright/OSMBright.xml
sed -i 's/CDATA\[USER_PLACEHOLDER\]/CDATA\['$USERNAME'\]/g' ../mod-tile-docker/OSMBright/OSMBright.xml

