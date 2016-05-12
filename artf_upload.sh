#/bin/bash
deploy_url=""
user=
password=
root_path=${1:="."}

source ~/.profile

function upload_artifact() {
	#echo ${1#$root_path/}
	if ! [[ ${1#$root_path/} =~ ^com/sap/fs|^fs ]]; then
		if [ -f ${1%.pom}.jar ]; then 
			echo "uploading ${1%.pom}.jar"
			curl -F r=thirdparty -F hasPom=true -F e=jar \
				-F file=@${1} \
				-F file=@${1%.pom}.jar \
				-u ${user}:${password} ${deploy_url}
			echo ""
	  	else
	  		echo "${1%.pom}.jar is not found! Only pom will be uploaded"
	  		curl -F r=thirdparty -F hasPom=true -F e=jar \
				-F file=@${1} \
				-u ${user}:${password} ${deploy_url}
			echo ""
	  	fi
	fi
}

find $root_path -name *.pom | while read file; do upload_artifact "$file"; done

