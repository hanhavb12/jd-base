#!/usr/bin/env bash

## Author: Evine Deng
## Source: https://github.com/EvineDeng/jd-base
## Modified： 2020-12-24
## Version： v3.0.0

## 文件路径、脚本网址、文件版本以及各种环境的判断
if [ -f /proc/1/cgroup ]
then
  isDocker=$(cat /proc/1/cgroup | grep docker)
else
  isDocker=""
fi

if [ -z "${isDocker}" ]
then
  ShellDir=$(cd $(dirname $0); pwd)
else
  ShellDir=${JD_DIR}
fi

LogDir=${ShellDir}/log
ScriptsDir=${ShellDir}/scripts
FileConf=${ShellDir}/config/config.sh
DateToday=$(date "+%Y-%m-%d")

## 东东小窝，一天一变
function Cat_ScodesSmallHome {
  cd ${LogDir}/jd_small_home
  if [[ $(ls -r | grep "${DateToday}") != "" ]]; then
    for log in $(ls -r | grep "${DateToday}")
    do
      ScodesSmallHome=$(grep "您的东东小窝shareCode" ${log} | perl -pe "s|.+【(\d+)】|\1|")
      [ -n "${ScodesSmallHome}" ] && break
    done
  fi
}

## 东东农场
function Cat_ScodesFruit {
  cd ${LogDir}/jd_fruit
  for log in $(ls -r)
  do
    ScodesFruit=$(grep "的东东农场好友互助码" ${log} | perl -pe "s|【京东账号\d+（(.+)）的东东农场好友互助码】(\w+)|\2|" | uniq)
    [ -n "${ScodesFruit}" ] && break
  done
}

## 东东萌宠
function Cat_ScodesPet {
  cd ${LogDir}/jd_pet
  for log in $(ls -r)
  do
    ScodesPet=$(grep "的东东萌宠好友互助码" ${log} | perl -pe "s|【京东账号\d+（(.+)）的东东萌宠好友互助码】(.+)|\2|" | uniq)
    [ -n "${ScodesPet}" ] && break
  done
}

## 种豆得豆
function Cat_ScodesBean {
  cd ${LogDir}/jd_plantBean
  for log in $(ls -r)
  do
    ScodesBean=$(grep "的京东种豆得豆好友互助码" ${log} | perl -pe "s|【京东账号\d+（(.+)）的京东种豆得豆好友互助码】(.+)|\2|" | uniq)
    [ -n "${ScodesBean}" ] && break
  done
}

## 京喜工厂
function Cat_ScodesJx {
  cd ${LogDir}/jd_dreamFactory
  for log in $(ls -r)
  do
    ScodesJx=$(grep "的京喜工厂好友互助码" ${log} | perl -pe "s|【京东账号\d+（(.+)）的京喜工厂好友互助码】(.+)|\2|" | uniq)
    [ -n "${ScodesJx}" ] && break
  done
}

## 东东工厂
function Cat_ScodesDd {
  cd ${LogDir}/jd_jdfactory
  for log in $(ls -r)
  do
    ScodesDd=$(grep "的东东工厂好友互助码" ${log} | perl -pe "s|【京东账号\d+（(.+)）的东东工厂好友互助码】(.+)|\2|" | uniq)
    [ -n "${ScodesDd}" ] && break
  done
}

## 疯狂的JOY
function Cat_ScodesJoy {
  cd ${LogDir}/jd_crazy_joy
  for log in $(ls -r)
  do
    ScodesJoy=$(grep "您的助力码为" ${log} | awk -F ": " '{print $2}' | uniq)
    [ -n "${ScodesJoy}" ] && break
  done
}

## 京东赚赚
function Cat_ScodesZz {
  cd ${LogDir}/jd_jdzz
  for log in $(ls -r)
  do
    ScodesZz=$(grep "的京东赚赚好友互助码" ${log} | perl -pe "s|【京东账号\d+（(.+)）的京东赚赚好友互助码】(.+)|\2|" | uniq)
    [ -n "${ScodesZz}" ] && break
  done
}

## 健康抽奖机，短期
function Cat_ScodesHealth {
  cd ${LogDir}/jd_health
  for log in $(ls -r)
  do
    ScodesHealth=$(grep "您的健康抽奖机好友助力邀请码" ${log} | awk -F "：" '{print $2}' | uniq)
    [ -n "${ScodesHealth}" ] && break
  done
}

## 京东健康，短期
function Cat_ScodesJdh {
  cd ${LogDir}/jd_jdh
  for log in $(ls -r)
  do
    ScodesJdh=$(grep "您的分享助力码为" ${log} | awk -F "：" '{print $2}' | uniq)
    [ -n "${ScodesJdh}" ] && break
  done
}

## 汇总
function Cat_All {
  echo "东东小窝（一天一变）："
  Cat_ScodesSmallHome
  if [ -n "${ScodesSmallHome}" ]
  then
    echo -e "${ScodesSmallHome}\n"
  else
    echo -e "东东小窝互助码一天一变，未检测到今天的日志...\n"
  fi

  echo "东东农场："
  Cat_ScodesFruit
  echo -e "${ScodesFruit}\n"

  echo "东东萌宠："
  Cat_ScodesPet
  echo -e "${ScodesPet}\n"

  echo "种豆得豆："
  Cat_ScodesBean
  echo -e "${ScodesBean}\n"

  echo "京喜工厂："
  Cat_ScodesJx
  echo -e "${ScodesJx}\n"

  echo "东东工厂："
  Cat_ScodesDd
  echo -e "${ScodesDd}\n"

  echo "疯狂的JOY："
  Cat_ScodesJoy
  echo -e "${ScodesJoy}\n"

  echo "京东赚赚："
  Cat_ScodesZz
  echo -e "${ScodesZz}\n"

  echo "健康抽奖机（短期）："
  Cat_ScodesHealth
  echo -e "${ScodesHealth}\n"

  echo "京东健康（短期）："
  Cat_ScodesJdh
  echo -e "${ScodesJdh}\n"
}

## 执行并写入日志
LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
LogFile="${LogDir}/export_sharecodes/${LogTime}.log"
[ ! -d "${LogDir}/export_sharecodes" ] && mkdir -p ${LogDir}/export_sharecodes
touch ${LogFile}
Cat_All | tee ${LogFile}