source erro.sh
versao1=$(git rev-parse HEAD | cut -c 1-7)
echo $versao1
data=$(date '+%Y-%m-%d')
echo $data
versao="${versao1}_${data}"
echo $versao
ECR_ID=557772028142.dkr.ecr.us-east-1.amazonaws.com
echo $ECR_ID
aws ecr get-login-password --region us-east-1 --profile bia-serverless | docker login --username AWS --password-stdin $ECR_ID
checar_ultimo_comando
docker build -t bia .
docker tag bia:latest $ECR_ID/bia:$versao
docker push $ECR_ID/bia:$versao
rm .env 2> /dev/null
rm bia-versao.zip 2> /dev/null
#------GERA COMPOSE-----------v1 BEANSTALK
#echo TAG=$versao >> .env
#echo ECR_ID1=$ECR_ID >> .env
#docker compose -f docker-compose-eb.yml config >> docker-compose-dev.yml
#mv docker-compose-dev.yml docker-compose.yml
#./gerar-compose.sh
#------GERA COMPOSE-----------v2 - ALB + BEANSTALK
#rm  docker-compose-dev.yml 2> /dev/null
rm  docker-compose-dev2.yml 2> /dev/null
rm  docker-compose-dev3.yml 2> /dev/null
echo TAG=$versao >> .env
echo ECR_ID1=$ECR_ID >> .env
docker compose -f docker-compose-eb.yml config --no-normalize >> docker-compose-dev.yml
gsed -i '/^name:/d' docker-compose-dev.yml
gsed -i '/container_name: bia/a container_name: bia1' docker-compose-dev.yml
gsed -i 's/container_name: bia1/    env_file: .env/g' docker-compose-dev.yml
#
#gsed -i '/container_name: bia/container_name: bia1' docker-compose-dev.yml
#
#gsed -i '/server:$/a \ container_name: bia' docker-compose-dev.yml
#gsed -e "s/\r//g" docker-compose-dev.yml > docker-compose-dev2.yml
#rm  docker-compose-dev.yml 2> /dev/null
#cat  docker-compose-dev2.yml | col -b > docker-compose-dev3.yml
#rm  docker-compose-dev2.yml 2> /dev/null
mv docker-compose-dev.yml docker-compose.yml
#-----------------SEM O *EB CLI*----OBS: COmenta e descomenta de acordo com uso
#rm bia-versao-*zip
#zip -r bia-versao-$versao.zip docker-compose.yml
#-----------------VIA  *EB CLI*----OBS: COmenta e descomenta de acordo com uso.
rm bia-versao.zip 2> /dev/null
zip -r bia-versao.zip docker-compose.yml
#-------------------------------
git checkout docker-compose.yml
