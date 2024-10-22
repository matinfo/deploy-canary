#!/bin/bash
RE='^[0-9]+$'
CONF_FILE=./nginx/loadbalancer/conf.d/default.conf

# Vérification du paramètre passé au script
if [ -z "$1" ]; then
  echo "Usage: ./update.sh new=<value> ou old=<value>"
  exit 1
fi

# Extraire la nouvelle valeur et le serveur (new ou old)
PARAM=$1
SERVER_TYPE=$(echo $PARAM | cut -d'=' -f1)
NEW_WEIGHT=$(echo $PARAM | cut -d'=' -f2)


# Vérifier que le fichier existe
if [ ! -f "$CONF_FILE" ]; then
  echo "Erreur: Fichier de configuration '$CONF_FILE' non trouvé."
  exit 1
fi

# Modifier le fichier en fonction du serveur (web-new ou web-old)
if [ "$SERVER_TYPE" == "new" ]; then
  # Modifier le weight pour web-new
  sed -i "/server web-new:80/s/weight=[0-9]*/weight=$NEW_WEIGHT/" $CONF_FILE
  echo "Mise à jour réussie : weight modifié en weight=$NEW_WEIGHT pour 'server web-new:80'"
elif [ "$SERVER_TYPE" == "old" ]; then
  # Modifier le weight pour web-old
  sed -i "/server web-old:80/s/weight=[0-9]*/weight=$NEW_WEIGHT/" $CONF_FILE
  echo "Mise à jour réussie : weight modifié en weight=$NEW_WEIGHT pour 'server web-old:80'"
else
  echo "Erreur: Paramètre invalide. Utilisez new=<value> ou old=<value>."
  exit 1
fi

SETTINGS_TIMESTAMP=$(date +%s)  docker stack deploy -c docker-stack.yml canary


