#!/bin/sh -e

function installAchievements {
    if [ ! -d "/server/world/datapacks/BlazeandCave-Advancements" ]; then
        echo "The installation of new achievements has begun."
        unzip /server/files/datapacks/BlazeandCaves-Advancements-Pack-1.14.5.zip -d /server/files/datapacks/BlazeandCave-Advancements
        mv /server/files/datapacks/BlazeandCave-Advancements /server/world/datapacks
        echo "New achievements have been installed :D"
    fi
}

function installMods {
    if [ ! -d "/server/mods" ]; then
        mkdir /server/mods
    fi

    function installMod {
        if [ ! -e "/server/mods/${2}" ]; then
            curl -L -o ./${2} ${1}
            mv ./${2} /server/mods
            echo "The mod was successfully installed: ${2}"
        fi
    }

    # * FabricAPI
    installMod "https://github.com/FabricMC/fabric/releases/download/0.57.0%2B1.19/fabric-api-0.57.0+1.19.jar" "fabric-api-0.57.0+1.19.jar"

    # * Terralith
    installMod "https://mediafiles.forgecdn.net/files/3874/530/Terralith_v2.3.2.jar" "Terralith_v2.3.2.jar"

    # * PlasmoVoice
    installMod "https://mediafiles.forgecdn.net/files/3863/790/plasmovoice-fabric-1.19-1.2.17.jar" "plasmovoice-fabric-1.19-1.2.17.jar"

    # * EmoteCraft
    installMod "https://mediafiles.forgecdn.net/files/3828/191/emotecraft-for-MC1.19-2.1.3-SNAPSHOT-build.30-fabric.jar" "emotecraft-for-MC1.19-2.1.3-SNAPSHOT-build.30-fabric.jar"

    # * FerriteCore
    installMod "https://mediafiles.forgecdn.net/files/3824/694/ferritecore-5.0.0-fabric.jar" "ferritecore-5.0.0-fabric.jar"

    # * Lithium
    installMod "https://github.com/CaffeineMC/lithium-fabric/releases/download/mc1.19-0.8.1/lithium-fabric-mc1.19-0.8.1-api.jar" "lithium-fabric-mc1.19-0.8.1.jar"

    # * MiniMOTD
    installMod "https://mediafiles.forgecdn.net/files/3838/355/minimotd-fabric-mc1.19-2.0.8.jar" "minimotd-fabric-mc1.19-2.0.8.jar"
    
    # * ServerCore
    installMod "https://mediafiles.forgecdn.net/files/3821/394/servercore-1.3.0-1.19.jar" "servercore-1.3.0-1.19.jar"

    # * Starlight
    installMod "https://mediafiles.forgecdn.net/files/3835/973/starlight-1.1.1%2Bfabric.ae22326.jar" "starlight-1.1.1.jar"
    
    # * c2me
    installMod "https://github.com/RelativityMC/C2ME-fabric/releases/download/0.2.0%2Balpha.8/c2me-fabric-mc1.19-0.2.0+alpha.8.2.jar" "c2me-fabric-mc1.19-0.2.0+alpha.8.2.jar"

    # # * TabTPS
    # installMod "https://github.com/jpenilla/TabTPS/releases/download/v1.3.14/tabtps-fabric-mc1.19-1.3.14.jar" "tabtps-fabric-mc1.19-1.3.14.jar"

    # ? Install emotes for mod Emotecraft
    mv /server/files/emotes /server/emotes
}

function configs {
    # * MiniMOTD
    if [ -d "/server/files/MiniMOTD" ]; then
        rm -rf /server/config/MiniMOTD
    fi
    mv -f /server/files/MiniMOTD /server/config
}

if [ ! -d "/server/world/datapacks" ]; then
    if [ ! -d "/server/world" ]; then
        mkdir /server/world
    fi

    mkdir /server/world/datapacks
fi

installAchievements

installMods

configs

if [ ! -d "/server/config" ]; then
    mkdir /server/config
fi

if [ ! -f "/server/config/banned-ips.json" ]; then
    echo "[]" >> /server/config/banned-ips.json
fi

if [ ! -f "/server/config/banned-players.json" ]; then
    echo "[]" >> /server/config/banned-players.json
fi

if [ ! -f "/server/config/usercache.json" ]; then
    echo "[]" >> /server/config/usercache.json
fi

if [ ! -f "/server/config/whitelist.json" ]; then
    echo "[]" >> /server/config/whitelist.json
fi

if [ ! -f "/server/config/ops.json" ]; then
    echo "[]" >> /server/config/ops.json
fi

ln -s /server/config/banned-ips.json /server/banned-ips.json
ln -s /server/config/banned-players.json /server/banned-players.json
ln -s /server/config/usercache.json /server/usercache.json
ln -s /server/config/whitelist.json /server/whitelist.json
ln -s /server/config/ops.json /server/ops.json

eval "echo \"$(cat ./server.properties)\"" > /server/server.properties

java -Xmx${JAVA_MEMORY} -Xms${JAVA_MEMORY} -Dfml.queryResult=confirm -jar fabric-server-launch.jar nogui