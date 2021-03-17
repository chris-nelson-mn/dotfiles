function update-content-stage {
  aws s3 mb s3://content01-stage-backup --profile shared
  heroku pg:backups:capture --app zipnosis-content-production
  heroku pg:backups:download --app zipnosis-content-production
  aws s3 cp latest.dump s3://content01-stage-backup/ --profile shared
  heroku pg:backups:restore "$(aws s3 presign s3://content01-stage-backup/latest.dump --expires-in 7200 --profile shared)" DATABASE_URL --app zipnosis-content01-stage --confirm zipnosis-content01-stage
  aws s3 rb s3://content01-stage-backup --force --profile shared
  rm latest.dump
}
