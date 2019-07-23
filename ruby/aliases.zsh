alias sc='script/console'
alias sg='script/generate'
alias sd='script/destroy'

alias bx='bundle exec'
alias devup='git checkout develop && git pull && bundle && bx rake db:migrate && bx rake db:test:prepare'
alias reup='bundle && bx rake db:migrate && bx rake db:test:prepare'
alias railsup='foreman start'
