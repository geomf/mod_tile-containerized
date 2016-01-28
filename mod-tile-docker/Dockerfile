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

FROM debian:7

# Installing the required packages
RUN apt-get update && apt-get install -y \
    libboost-all-dev \
    subversion \
    git-core \
    tar \
    unzip \
    wget \
    bzip2 \
    build-essential \
    autoconf \
    libtool \
    libxml2-dev \
    libgeos-dev \
    libgeos++-dev \
    libpq-dev \
    libbz2-dev \
    libproj-dev \
    munin-node \
    munin \
    libprotobuf-c0-dev \
    protobuf-c-compiler \
    libfreetype6-dev \
    libpng12-dev \
    libtiff4-dev \
    libicu-dev \
    libgdal-dev \
    libcairo-dev \
    libcairomm-1.0-dev \
    apache2 \
    apache2-dev \
    libagg-dev \
    liblua5.2-dev \
    ttf-unifont \
    lua5.1 \
    liblua5.1-dev \
    node-carto \
    libgeotiff2 \
    supervisor

#Installing mapnik
RUN mkdir ~/src && cd ~/src && git clone http://github.com/mapnik/mapnik && cd mapnik && git branch 2.2 origin/2.2.x && git checkout 2.2 && python scons/scons.py configure INPUT_PLUGINS=all OPTIMIZATION=3 SYSTEM_FONTS=/usr/share/fonts/truetype/ && make && sudo make install && sudo ldconfig

#Installing mod_tile and renderd
RUN cd ~/src && git clone http://github.com/openstreetmap/mod_tile.git && cd mod_tile && ./autogen.sh && ./configure && make && sudo make install && sudo make install-mod_tile && sudo ldconfig

#Create required directoties
RUN mkdir -p /usr/local/share/maps/style && mkdir /var/run/renderd && mkdir /var/lib/mod_tile && mkdir -p /var/log/supervisor

#Add shape files
ADD shp /usr/local/share/maps/style/shp

#Add OSMBright style files
ADD OSMBright /usr/local/share/maps/style/OSMBright

#Add renderd configuration file
ADD renderd.conf /usr/local/etc/

#Add mod_tile configuration file
ADD mod_tile.conf /etc/apache2/conf-available/

#Add apache configuration file
ADD 000-default.conf /etc/apache2/sites-available/

ADD renderd /etc/init.d/

ADD supervisord.conf /etc/supervisor/conf.d/

#Run mod_tile module in apache
RUN a2enconf mod_tile

EXPOSE 80

CMD ["/usr/bin/supervisord"]
