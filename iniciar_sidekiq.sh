#!/bin/bash

echo "➡️  Entrando na pasta do projeto..."
cd ~/i-diario || { echo "❌ Pasta ~/i-diario não encontrada."; exit 1; }
echo "✅ Pasta acessada com sucesso!"

echo "➡️  Iniciando o serviço PostgreSQL..."
if sudo service postgresql start; then
  echo "✅ PostgreSQL iniciado!"
else
  echo "❌ Falha ao iniciar PostgreSQL"
  exit 1
fi

echo "➡️  Iniciando o serviço Redis..."
if sudo service redis-server start; then
  echo "✅ Redis iniciado!"
else
  echo "❌ Falha ao iniciar Redis"
  exit 1
fi

echo "➡️  Ativando ambiente Ruby com rbenv..."
if eval "$(rbenv init -)"; then
  echo "✅ Ambiente Ruby ativado!"
else
  echo "❌ Falha ao ativar ambiente Ruby"
  exit 1
fi

echo "➡️  Compilando assets com Webpacker (se necessário)..."
if bundle exec rails webpacker:compile; then
  echo "✅ Webpacker compilado com sucesso!"
else
  echo "⚠️  Webpacker pode já estar compilado ou houve falha"
fi

echo "➡️  Iniciando o Sidekiq em background..."
if bundle exec sidekiq -d -L log/sidekiq.log; then
  echo "✅ Sidekiq iniciado (logs em log/sidekiq.log)!"
else
  echo "❌ Falha ao iniciar Sidekiq"
  exit 1
fi

echo "➡️  Iniciando o servidor Rails..."
if bundle exec rails s -b 0.0.0.0 -p 3000; then
  echo "✅ Servidor Rails iniciado!"
else
  echo "❌ Falha ao iniciar servidor Rails"
  exit 1
fi
