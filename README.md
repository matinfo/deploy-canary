## Canary - Docker Swarm nginx

La solution démontre le fonctionnement du déploiement de type Canary avec 
un service nginx et en front un load-balancer nginx utilisant un stack Swarm.

Cette solution utilise des 'configs' docker swarm pour partager sur les nodes 
les configurations de chaque service nginx et des fichiers index.html spécifique 
pour afficher sur l'instance 1 *Welcome Canary Old* et pour l'instance 2 *Welcome Canary New*.

Le load balancer est accessible sur le port http **8484**.

**Créer la stack 'canary'**

```bash
bash deploy.sh
```

**Ajouter plus d'utilisateur à l'instance New**

```bash
bash update.sh new=9

ou moins à l'instance old

bash update.ch old=1
```

Pour voir le comportement, rechercher à plusieurs reprise la page dans votre navigateur internet.

Afin de permettre d'augmenter l'usage service *new* la config du load-balancer est
créer dans docker avec un nom (name) changent à chaque 'switch'. C'est un bon moyen pour forcer 
swarm à modifier le comportement du load-balancer, car une *config* ne peux être modifier (update).

```yaml
  loadbalancer_conf:
    name: default-${SETTINGS_TIMESTAMP}.conf
    file: ./nginx/loadbalancer/conf.d/default.conf
```

Il est donc nécéssaire de deployer la stack avec la ligne de commande suivante:

```bash
SETTINGS_TIMESTAMP=$(date +%s)  docker stack deploy -c docker-stack.yml canary
```



> A noter: Utiliser des 'config' pour les fichiers des 2 index.html personnalisés Bleu et Green n'est pas une bonne pratique, mais uniquement par simplicité! Dans un vrais contexte, il faudrait utiliser soit des volumes nommés, soit des répertoires partagés type NFS ou encore dans des images docker spécifiques. 