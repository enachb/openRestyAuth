sudo pkill -f nginx
sudo openresty -p `pwd` -c conf/nginx.conf
