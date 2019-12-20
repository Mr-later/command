checkParameter() {
	ymlProfiles=$1
	artifactId=$2
    appPath="/app/$loginUser/${ymlProfiles}/${artifactId}"
	javaSystemProperty='-Doracle.jdbc.DateZeroTime=true'
	javaProgramArgument=''
	appStartCMD=''
	if [[ -n ${ymlProfiles} && '' != ${ymlProfiles} ]]; then
		if [[ -n ${artifactId} && '' != ${artifactId} ]]; then
			echo -e "\033[31m ymlProfiles: ${ymlProfiles} \033[0m"
			echo -e "\033[31m artifactId: ${artifactId} \033[0m"
			return
		fi
	fi
	echo -e "\033[31m ERROR: 参数不为空 \n\t例: sh startup.sh dev app.jar \033[0m"
	exit 1
}
checkUser() {
	loginUser=$(whoami)
	if [ "root" = ${loginUser} ]; then
		echo -e "\033[31m ERROR: 不能用root用户执行 \033[0m"
		exit 1
	fi
	echo -e "\033[31m loginUser: $loginUser \033[0m"
}
checkPathAndFile() {
	echo -e "\033[31m appPath: ${appPath} \033[0m"
	if [ ! -d "${appPath}" ]; then
		mkdir -p "${appPath}"
    	if [ ! -d "${appPath}" ]; then
            echo -e "\033[31m ERROR: 目录 ${appPath} 创建失败 \033[0m"
            exit 1
        fi
	fi
	appJar=${appPath}'/'${artifactId}'.jar'
	appYml=${appPath}'/'${artifactId}'.yml'
	mv ${artifactId}.yml ${artifactId}.jar -t ${appPath}
	if [ -e ${appJar} ]; then
		if [ -e ${appYml} ]; then
			javaProgramArgument=" --spring.profiles.active=${ymlProfiles}"
			appStartCMD="java ${javaSystemProperty} -jar ${appJar} ${javaProgramArgument}"
			break
		else
			echo -e "\033[31m ERROR: 文件 ${appYml} 不存在 \033[0m"
			exit 0
		fi
	else
		echo -e "\033[31m ERROR: 文件 ${appJar} 不存在 \033[0m"
		exit 1
	fi
}

getAppPort() {
	appPort=''
	appProfilesRowNo=$(egrep -n "^.*profiles: ${ymlProfiles}$" ${appYml} | awk '{print $1}' | cut -f1 -d ':')
    echo -e "\033[31m egrep -n \"^.*profiles: ${ymlProfiles}$\" ${appYml} | awk '{print \$1}' | cut -f1 -d ':' \033[0m"
	if [[ '' == "${appProfilesRowNo}" ]]; then
		echo -e "\033[31m ERROR: 在 ${ymlProfiles} 环境配置中找不到应用端口号 \033[0m"
		exit 1
	fi
	echo -e "\033[31m appProfilesRowNo: ${appProfilesRowNo} \033[0m"
	appServerRowNoArr=($(egrep -n "^server:" ${appYml} | awk '{print $1}' | cut -f1 -d ':'))
	if [ "0" = "${#appServerRowNoArr[@]}" ]; then
		echo -e "\033[31m ERROR: 在 ${ymlProfiles} 环境配置中找不到server.port参数 \033[0m"
		exit 1
	fi
	echo -e "\033[31m appServerRowNoArr: ${appServerRowNoArr[@]} \033[0m"
	i=$(expr ${#appServerRowNoArr[@]} - 1)
	while [[ $i -ge 0 ]]; do
		if [[ ${appProfilesRowNo} -gt ${appServerRowNoArr[$i]} ]]; then
			appPort=$(sed -n $(expr ${appServerRowNoArr[$i]} + 1)p ${appYml} | awk '{print $2}')
			echo -e "\033[31m appPort: ${appPort} \033[0m"
			break
		fi
		let i--
	done
}

getAppPID() {
	appPID=$(ps -ef | grep -v grep | grep "^.*${appJar}.*${ymlProfiles}" | sed -n '1P' | awk '{print $2}')
}

appStart() {
        cd ${appPath}
	nohup ${appStartCMD} > ${artifactId}.log 2>&1 &
	appStatus
}

appRestart() {
	appStop
	appStart
}

appStatus() {
	getAppPID
	if [[ '' != ${appPID} ]]; then
		echo -e "\033[31m ${artifactId} 正在运行... pid: ${appPID} \033[0m"
	else
		echo -e "\033[31m ${artifactId} 未运行...  \033[0m"
	fi
}

appStop() {
	appStatus
	if [[ '' != ${appPID} ]]; then
		curl  --connect-timeout 10 -m 5 -d "" "127.0.0.1:${appPort}/shutdown"
		shutdownToKillTimeOut=10
		while [[ true ]]; do
			getAppPID
			if [[ '' != ${appPID} ]]; then
				if [[ ${shutdownToKillTimeOut} -ge 0 ]]; then
					echo -e "\033[31m shutdown超时时间: ${shutdownToKillTimeOut}s \033[0m"
					sleep 1s
				else
					echo -e "\033[31m 执行kill -9 ${appPID} \033[0m"
					kill -9 ${appPID}
				fi
			else
				echo -e "\033[31m ${artifactId} 已停止...  \033[0m"
				break
			fi
			let shutdownToKillTimeOut--
		done
	fi
}
checkUser
checkParameter $1 $2
checkPathAndFile
getAppPort
appRestart
