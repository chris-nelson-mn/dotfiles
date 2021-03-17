function on-training {
  kubectx arn:aws:eks:us-east-1:806543834481:cluster/training
}

function on-demo {
  kubectx arn:aws:eks:us-east-1:806543834481:cluster/demo
}

function on-mirth {
  kubectx arn:aws:eks:us-east-1:806543834481:cluster/mirth
}

function on-erx {
  kubectx arn:aws:eks:us-east-1:806543834481:cluster/erx
}

function on-statnosis {
  kubectx arn:aws:eks:us-east-1:806543834481:cluster/statnosis
}

function on-production {
  kubectx arn:aws:eks:us-east-1:806543834481:cluster/production
}

function check-sidekiq-deployment {
  kubectl -n zip1 rollout status deployment/sidekiq-deployment
}

function check-zipnosis-deployment {
  kubectl -n zip1 rollout status deployment/zipnosis-deployment
}

function start-console {
  # check-sidekiq-deployment
  # check-zipnosis-deployment
  kubectl exec -itn zip1 $(kubectl get pod -n zip1 -o name --field-selector=status.phase=Running | grep --color=never -i 'zipnosis-deployment' | shuf -n 1) -- /bin/bash -c 'source .profile.d/ruby.sh; rails c'
}

function start-sidekiq-console {
  # check-sidekiq-deployment
  # kubectl exec -itn zip1 $(kubectl -n zip1 get pod -o name --field-selector=status.phase=Running | grep --color=never -i 'sidekiq-deployment' | shuf -n 1) -- /bin/bash -c 'source .profile.d/ruby.sh; rails c'
  kubectl exec -itn zip1 --container sidekiq $(kubectl get pod -n zip1 -o name --field-selector=status.phase=Running | grep --color=never -i 'sidekiq-deployment' | shuf -n 1) -- /bin/bash -c 'source .profile.d/ruby.sh; rails c'
}

function training-console {
  on-training
  start-sidekiq-console
}

function demo-console {
  on-demo
  start-sidekiq-console
}

function mirth-console {
  on-mirth
  # login
}

function production-console {
  on-production
  start-console
}

function erx-console {
  on-erx
  start-console
}

function statnosis-console {
  on-statnosis
  start-sidekiq-console
}

function migrate-database {
  # check-sidekiq-deployment
  # check-zipnosis-deployment
  kubectl exec -itn zip1 $(kubectl get pod -o name --field-selector=status.phase=Running | grep --color=never -i 'zipnosis-deployment' | shuf -n 1) -- /bin/bash -c 'source .profile.d/ruby.sh; bundle exec rake db:migrate'
}

function training-migration {
  on-training
  migrate-database
}

function production-migration {
  on-production
  migrate-database
}

function erx-migration {
  on-erx
  migrate-database
}

function statnosis-migration {
  on-statnosis
  migrate-database
}

function build-training {
  aws codebuild start-build --project-name zipnosis-develop --profile shared
}

function deploy-latest {
  kubectl -n zip1 rollout restart deployment/sidekiq-deployment
  kubectl -n zip1 rollout restart deployment/zipnosis-deployment
  kubectl -n zip1 rollout restart deployment/sidekiq-deployment
}

function deploy-training {
  on-training
  deploy-latest
}
