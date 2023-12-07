docker run -d -p 8080:80 -p 3036 -v themes:/var/www/html/Themes -v plugins:/var/www/html/IdnoPlugins --name website-container website 
docker exec -ti website-container /bin/bash