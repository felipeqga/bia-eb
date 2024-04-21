#-------
#--no-normalize= Remove info de network no docker-compose.yml
source erro.sh
versao1=$(git rev-parse HEAD | cut -c 1-7)
echo $versao1
data=$(date '+%Y-%m-%d')
echo $data
versao="${versao1}_${data}"
echo $versao
ECR_ID=557772028142.dkr.ecr.us-east-1.amazonaws.com
echo $ECR_ID
rm .env 2> /dev/null
rm docker-compose-v2.yml
echo TAG=$versao >> .env
docker compose -f docker-compose-eb.yml config --no-normalize >> docker-compose-dev.yml
gsed -i '/^name:/d' docker-compose-dev.yml
gsed -i '/server:$/a \ env_file: .env' docker-compose-dev.yml
mv docker-compose-dev.yml docker-compose-v2.yml
