API_ENDPOINT=http://d21eenlyotykxe.cloudfront.net
BUCKET_S3=bia-cdn
PROFILE1=bia-serverless
REACT_APP_API_URL=$API_ENDPOINT SKIP_PREFLIGHT_CHECK=true npm run build --prefix client
echo '>> Fazendo deploy dos assets'
aws s3 sync client/build s3://$BUCKET_S3/ --exclude "index.html" --profile $PROFILE1

echo '>> Fazendo deploy do index.html'
aws s3 sync client/build s3://$BUCKET_S3/ --exclude "*" --include "index.html" --profile $PROFILE1

#aws s3 sync client/build s3://bia-cdn/ --exclude "index.html" --profile bia-serverless