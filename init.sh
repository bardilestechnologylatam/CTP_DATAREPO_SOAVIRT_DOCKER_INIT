
#!/bin/bash

# PRE BUILD SOAVIRT SERVER
current_directory="$(pwd)"
pre_build_directory_sv="/PRE_SOAVIRT_IMAGE"
pre_build_workspace_sv="$current_directory$pre_build_directory_sv"
echo "Pre build Soavirt server image"
docker build -t soavirt_web_lss "$pre_build_workspace_sv"
cd "$project_directory" || exit # salir al directorio del proyecto
sleep 5

# PRE BUILD CTP SERVER
pre_build_directory_ctp="/PRE_CTP_IMAGE"
pre_build_workspace_ctp="$current_directory$pre_build_directory_ctp"
echo ""
echo "Pre build CTP image"
docker build --no-cache --build-arg USER_ID=1006 --build-arg GROUP_ID=1006 --build-arg USER_NAME=sysadmin -t ctp_conf "$pre_build_workspace_ctp"
cd "$project_directory" || exit

# Ejecuta tu docker-compose desde la raíz del proyecto
docker-compose up -d
sleep 20
echo "Comandos manuales no me funciono lo otro :C"
docker-compose run -u 0 ctp_conf chmod 777 -R /usr/local/parasoft/ctp
docker restart -d ctp_conf
sleep 20


# EJEMPLO: curl -s -o /dev/null -w "%{http_code}" http://www.ejemplo.com
http_code=$(curl -s -o /dev/null -w "%{http_code}" -X 'GET' \
  'http://localhost:8080/em/api/v3/environments?limit=50&offset=0' \
  -H 'accept: application/json')

# Verificar el código de retorno
if [ $http_code -eq 200 ]; then
    compose_datarepo="docker-compose-datarepo.yml"
    path_datarepo_compose="$current_directory/$compose_datarepo"
    docker-compose -f "$path_datarepo_compose" up -d
else
    echo "Hubo un problema en la solicitud (código de retorno $http_code)"
fi

