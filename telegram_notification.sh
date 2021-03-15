# cron job config
# crontab -e
#*/10 * * * * /root/mec-rpc-docker/telegram_notification.sh > /var/log/telegram_notificationy.log 2>&1

# find MN_TELEGRAM_GROUP_ID
#curl https://api.telegram.org/bot${MN_TELEGRAM_BOT_TOKEN}/getUpdates

usage()
{
   echo "Usage:"
   echo "    telegram_notification.sh -h                    Display this help message"
}

while getopts ":h" opt; do
  case ${opt} in
    h )
      usage
      exit 0
      ;;
   \? )
     echo "Invalid Option: -$OPTARG" 1>&2
     exit 1
     ;;
  esac
done
shift $((OPTIND -1))

dpkg-query -l python3-pip
if [ $? -ne 0 ] ; then
   apt-get install -y python3-pip
fi
#Telegram CLI
# git: https://github.com/erayerdin/tgcli
# doku: https://tgcli.readthedocs.io/en/master
pip3 list | grep -F tgcli
if [ $? -ne 0 ] ; then
   pip3 install tgcli
fi

pushd /root/mec-rpc-docker/ >/dev/null
source .env
CHECK_HEALTH=$(docker ps | grep "unhealthy")
    if [ -n "$CHECK_HEALTH" ]; then
        ERROR_MSG="The megacoin-rpc docker container is unhealthy."
        TELEGRAM_MSG="$ELECTRUM_SERVER : $ERROR_MSG"
        /usr/local/bin/tgcli bot -t "$MN_TELEGRAM_BOT_TOKEN" send -r "$MN_TELEGRAM_GROUP_ID" message "$TELEGRAM_MSG"
    fi

CHECK_RESTART=$(docker ps | grep "Restarting")
    if [ -n "$CHECK_RESTART" ]; then
        ERROR_MSG="The electrumx docker container restarts all the time."
        TELEGRAM_MSG="$ELECTRUM_SERVER : $ERROR_MSG"
        /usr/local/bin/tgcli bot -t "$MN_TELEGRAM_BOT_TOKEN" send -r "$MN_TELEGRAM_GROUP_ID" message "$TELEGRAM_MSG"
    fi

CHECK_EXIST_ELE=$(docker ps | grep "electrumx")
    if [ -z "$CHECK_EXIST_ELE" ]; then
        ERROR_MSG="The electrumx docker Container is down."
        TELEGRAM_MSG="$ELECTRUM_SERVER : $ERROR_MSG"
        /usr/local/bin/tgcli bot -t "$MN_TELEGRAM_BOT_TOKEN" send -r "$MN_TELEGRAM_GROUP_ID" message "$TELEGRAM_MSG"
    fi

CHECK_EXIST_MEC=$(docker ps | grep "megacoin-rpc")
    if [ -z "$CHECK_EXIST_MEC" ]; then
        ERROR_MSG="The megacoin-rpc docker Container is down"
        TELEGRAM_MSG="$ELECTRUM_SERVER : $ERROR_MSG"
        /usr/local/bin/tgcli bot -t "$MN_TELEGRAM_BOT_TOKEN" send -r "$MN_TELEGRAM_GROUP_ID" message "$TELEGRAM_MSG"
    fi

