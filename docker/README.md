
#connect
```
docker exec -it -u www-data $(docker-compose ps | grep "demo_app" | awk '{print $1}') bash
```
